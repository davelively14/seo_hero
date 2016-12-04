defmodule SeoHero.Validate do
  @contest_start_date {{2016, 11, 16}, {0, 0, 0}}

  #######
  # API #
  #######

  def check_domain(domain) do
    domain
    |> get_url
    |> get_creation_date
    |> is_eligible
  end

  ####################
  # Private Function #
  ####################

  def get_url(domain) do
    "https://www.whois.com/whois/#{domain}"
  end

  def get_creation_date(url) do
    case url |> String.split(".") |> List.last do
      "io" ->
        get_io(url)
      _ ->
        get_standard(url)
    end
  end

  defp get_io(url) do
    HTTPoison.get!(url)
    |> Map.get(:body) |> String.split("Expiry : ") |> Enum.at(1)
    |> String.split("<br>") |> List.first |> make_date_io
  end

  defp get_standard(url) do
    HTTPoison.get!(url)
    |> Map.get(:body) |> String.split("Creation Date: ") |> Enum.at(1)
    |> String.split("<br>") |> List.first |> make_date
  end

  def make_date_io(date) do
    [year, month, day] = date |> String.split("-")

    year = String.to_integer(year) - 1

    result = {{year, String.to_integer(month), String.to_integer(day)}, {0, 0, 0}}
    IO.inspect result
    IO.inspect @contest_start_date
    result
  end

  def make_date(date) do
    [day, month, year] = date |> String.split("-")
    month =
      case month do
        "jan" -> 1
        "feb" -> 2
        "mar" -> 3
        "apr" -> 4
        "may" -> 5
        "jun" -> 6
        "jul" -> 7
        "aug" -> 8
        "sep" -> 9
        "oct" -> 10
        "nov" -> 11
        "dec" -> 12
        _ -> String.to_integer(month)
      end

    result = {{String.to_integer(year), month, String.to_integer(day)}, {0, 0, 0}}
    IO.inspect result
    IO.inspect @contest_start_date
    result
  end

  def is_eligible(result_date), do: result_date >= @contest_start_date
end
