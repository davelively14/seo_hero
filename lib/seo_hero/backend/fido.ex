defmodule SeoHero.Fido do
  @default_url "https://www.google.com/search?q=seo+hero&near=new+york,new+york&sourceid=chrome&ie=UTF-8&num=21"
  @default_syntax "div.g"
  @num_page_results 9

  #######
  # API #
  #######

  # Will use defaults to get the SeoHero data.
  def fetch_data do
    HTTPoison.get!(@default_url, %{}, stream_to: self)
    receive_results(@default_syntax)
  end

  # Allows user to specific which syntax and which url to go after.
  def fetch_data(urls) when is_list(urls) do
    get_multiple_results(urls)
  end

  def fetch_data(url) do
    HTTPoison.get!(url, %{}, stream_to: self)
    receive_results(@default_syntax)
  end

  #############
  # Callbacks #
  #############

  # Server type of a function. Loops until it receives the relevant chunk of
  # data with the correct search results and returns them to calling function.
  defp receive_results(syntax, last_ranking \\ 0) do
    receive do
      %HTTPoison.AsyncChunk{chunk: chunk} ->
        chunk = chunk |> clean
        case responses = Floki.find(chunk, syntax) do
          [] ->
            receive_results(syntax)
          _ ->
            IEx.Helpers.flush
            parse(responses, last_ranking)
            # responses
        end
      %HTTPoison.AsyncEnd{id: _} ->
        {:done}
      _ ->
        receive_results(syntax)
    end
  end

  #####################
  # Private Functions #
  #####################

  defp get_multiple_results(urls), do: get_multiple_results(urls, 0)
  defp get_multiple_results([], _), do: []
  defp get_multiple_results([head | tail], last_ranking) do
    HTTPoison.get!(head, %{}, stream_to: self)
    results = receive_results(@default_syntax, last_ranking)
    results ++ get_multiple_results(tail, last_ranking + @num_page_results)
  end

  # Will take the chunk with relevant information and parse it. Returns a list
  # of result maps, each containing the domain name and url.
  defp parse(responses, last_ranking) do
    results =
      for resp <- responses do
        citation =
          case cite = resp |> Floki.find("cite") |> List.first do
            nil ->
              nil
            _ -> cite |> elem(2) |> plain_text |> domain_only
          end

        url =
          resp |> Floki.find("h3.r") |> Floki.find("a")
          |> Floki.attribute("href") |> List.first |> String.split("?q=")
          |> Enum.at(1) |> String.split("&") |> List.first

        snippet = resp |> Floki.find("span.st") |> get_snippet

        %{domain: citation, url: url, snippet: snippet}
      end

    results |> Enum.filter(&(&1.domain != nil)) |> add_rank(last_ranking)
  end

  # Will convert an HTML formatted element from Floki.find to a simple string.
  # Ex: ["https://www.seroundtable.com/wix-", {"b", [], ["seo"]}, "-", {"b", [], ["hero"]}, "-challenge-23020.html"]
  # Becomes: "https://www.seroundtable.com/wix-seo-hero-challenge-23020.html"
  defp plain_text(text), do: plain_text(text, "")
  defp plain_text([], result), do: result
  defp plain_text([head | tail], result) when is_tuple(head) do
    new_element = head |> elem(2) |> List.first
    cond do
      is_tuple(new_element) ->
        result <> plain_text([new_element])
      is_bitstring(new_element) ->
        plain_text(tail, result <> clean(new_element))
      true ->
        plain_text(tail, result)
    end
    # if is_tuple(new_element) do
    #   result <> plain_text([new_element])
    # else if is_string(new_element)
    #   plain_text(tail, result <> clean(new_element))
    # else
    #   plain_text(tail, result)
    # end
  end
  defp plain_text([head | tail], result), do: plain_text(tail, result <> clean(head))

  # Will reduce the entire url to just the domain without all the protocol.
  # Ex: https://www.seroundtable.com/wix-seo-hero-challenge-23020.html
  # Becomes: www.seroundtable.com
  defp domain_only(result) do
    case length(result = result |> String.split("//")) do
      1 ->
        result |> List.first |> String.split("/") |> List.first
      _ ->
        result |> Enum.at(1) |> String.split("/") |> List.first
    end
  end

  # Ensures a snippet is not blank. If it is, it will return nothing. Prevents
  # us from trying to run List.first on any nil values.
  defp get_snippet(snip) do
    if snip = List.first(snip) do
      snip = snip |> elem(2) |> plain_text |> String.replace("\n", "")
    end
  end

  # defp add_rank(results), do: add_rank(results, 1)
  defp add_rank([], _rank), do: []
  defp add_rank([head | tail], last_rank) do
    new_map = head |> Map.put(:rank, last_rank + 1)
    [new_map | add_rank(tail, last_rank + 1)]
  end

  defp clean(data), do: clean(String.codepoints(data), "")
  defp clean([], solution), do: solution
  defp clean([head | tail], solution) do
    if String.valid?(head) do
      clean(tail, solution <> head)
    else
      clean(tail, solution)
    end
  end
end
