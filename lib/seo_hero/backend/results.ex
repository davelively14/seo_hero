defmodule SeoHero.Results do
  @default_url "https://www.google.com/search?q=seo+hero&near=new+york,new+york&aqs=chrome..69i57.2804j0j9&sourceid=chrome&ie=UTF-8"
  @default_syntax "div.g"

  #######
  # API #
  #######

  # Will use defaults to get the SeoHero data.
  def fetch_data do
    HTTPoison.get!(@default_url, %{}, stream_to: self)
    receive_results(@default_syntax)
  end

  # Allows user to specific which syntax and which url to go after.
  def fetch_data(url, syntax \\ @default_syntax) do
    HTTPoison.get!(url, %{}, stream_to: self)
    receive_results(syntax)
  end

  #############
  # Callbacks #
  #############

  # Server type of a function. Loops until it receives the relevant chunk of
  # data with the correct search results.
  defp receive_results(syntax) do
    receive do
      %HTTPoison.AsyncChunk{chunk: chunk} ->
        case responses = Floki.find(chunk, syntax) do
          [] ->
            receive_results(syntax)
          _ ->
            parse(responses)
            # responses
        end
      %HTTPoison.AsyncEnd{id: _} ->
        {:error}
      _ ->
        receive_results(syntax)
    end
  end

  #####################
  # Private Functions #
  #####################

  # Will take the chunk with relevant information and parse it. Returns a list
  # of result maps, each containing the domain name and url.
  defp parse(responses) do
    results =
      for resp <- responses do
        citation =
          case cite = resp |> Floki.find("cite") |> List.first do
            nil ->
              nil
            _ -> cite |> elem(2) |> flatten_citation
          end

        url =
          resp |> Floki.find("h3.r") |> Floki.find("a")
          |> Floki.attribute("href") |> List.first |> String.split("?q=")
          |> Enum.at(1) |> String.split("&") |> List.first

        %{domain: citation, url: url}
      end

    results |> Enum.filter(&(&1.domain != nil))
  end

  # Will flatten a citation in order to any weird formatting.
  # Ex: ["https://www.seroundtable.com/wix-", {"b", [], ["seo"]}, "-", {"b", [], ["hero"]}, "-challenge-23020.html"]
  # Becomes: "https://www.seroundtable.com/wix-seo-hero-challenge-23020.html"
  defp flatten_citation(citation), do: flatten_citation(citation, "")
  defp flatten_citation([], result) do
    if result, do: domain_only(result)
  end
  defp flatten_citation([head | tail], result) when is_tuple(head) do
    new_element = head |> elem(2) |> List.first
    flatten_citation(tail, result <> new_element)
  end
  defp flatten_citation([head | tail], result), do: flatten_citation(tail, result <> head)

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
end
