defmodule SeoHero.Results do
  @default_url "https://www.google.com/search?q=seo+hero&near=new+york,new+york&aqs=chrome..69i57.2804j0j9&sourceid=chrome&ie=UTF-8"
  @default_syntax "div.g"

  #######
  # API #
  #######

  def fetch_data do
    HTTPoison.get!(@default_url, %{}, stream_to: self)
    receive_results(@default_syntax)
  end

  def fetch_data(syntax, url \\ @default_url) do
    HTTPoison.get!(url, %{}, stream_to: self)
    receive_results(syntax)
  end

  #####################
  # Private Functions #
  #####################

  defp receive_results(syntax) do
    receive do
      %HTTPoison.AsyncChunk{chunk: chunk} ->
        case resp = Floki.find(chunk, syntax) do
          [] ->
            receive_results(syntax)
          _ ->
            resp
        end
      %HTTPoison.AsyncEnd{id: _} ->
        {:error}
      _ ->
        receive_results(syntax)
    end
  end

  defp parse do

  end
end
