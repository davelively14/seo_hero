defmodule SeoHero.Validate do
  alias SeoHero.{Validation, Repo}

  @contest_start_date {{2016, 11, 16}, {0, 0, 0}}

  #######
  # API #
  #######

  # Returns true if domain meets contest crtieria, or false if it doesn't
  def check_domain(domain) do
    decon_url = domain |> String.split(".")
    clean_domain = "#{Enum.at(decon_url, length(decon_url) - 2)}.#{List.last(decon_url)}"

    if validation = get_validation(clean_domain) do
      validation.is_valid
    else
      clean_domain
      |> get_url
      |> get_creation_date
      |> is_valid(clean_domain)
    end
  end

  # TODO impelement
  # Given a valid file name, will save the contents of the Validate model to a
  # the specified file.
  def export_validation(file_name) when is_bitstring(file_name) do
    file_name
  end

  ####################
  # Private Function #
  ####################

  # Returns a Validation record corresponding with a given domain, or it will
  # return nil if result does not exist
  defp get_validation(domain) do
    Validation |> Repo.get_by(domain: domain)
  end

  defp get_url(domain) do
    "https://www.whois.com/whois/#{domain}"
  end

  defp get_creation_date(url) do
    IO.inspect url
    case url |> String.split(".") |> List.last do
      "io" ->
        get_io(url)
      "ninja" ->
        get_org(url)
      "center" ->
        get_org(url)
      "org" ->
        get_org(url)
      "co" ->
        get_co(url)
      "za" ->
        false
      "au" ->
        false
      "eu" ->
        false
      "uk" ->
        false
      "de" ->
        false
      "fr" ->
        # .fr does return results, but this contest does not allow for foreign
        # based domains
        false
      "es" ->
        false
      "at" ->
        false
      _ ->
        get_standard(url)
    end
  end

  defp get_org(url) do
    HTTPoison.get!(url)
    |> Map.get(:body) |> String.split("Creation Date: ") |> Enum.at(1)
    |> String.split("T") |> List.first |> make_date_io
  end

  defp get_io(url) do
    HTTPoison.get!(url)
    |> Map.get(:body) |> String.split("Expiry : ") |> Enum.at(1)
    |> String.split("<br>") |> List.first |> make_date_io
  end

  defp get_co(url) do
    raw_date =
      HTTPoison.get!(url)
      |> Map.get(:body) |> String.split("Domain Registration Date:")
      |> Enum.at(1) |> String.replace_leading("&nbsp;", "")
      |> String.split("<br>") |> List.first |> String.split(" ")
    [_, month, day, _, _, year] = raw_date
    "#{day}-#{month}-#{year}"
  end

  defp get_standard(url) do
    HTTPoison.get!(url)
    |> Map.get(:body) |> String.split("Creation Date: ") |> Enum.at(1)
    |> String.split("<br>") |> List.first |> make_data_standard
  end

  defp make_date_io(date) do
    [year, month, day] = date |> String.split("-")

    year = String.to_integer(year) - 1

    {{year, String.to_integer(month), String.to_integer(day)}, {0, 0, 0}}
  end

  defp make_data_standard(date) do
    [day, month, year] = date |> String.split("-")
    month =
      case String.downcase(month) do
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

    {{String.to_integer(year), month, String.to_integer(day)}, {0, 0, 0}}
  end

  # Given a date, will return true if eligible or false if not. Will store
  # results in the Repo.
  defp is_valid(result_date, domain) do
    result = result_date >= @contest_start_date

    changeset = Validation.changeset(%Validation{}, %{domain: domain, is_valid: result})
    Repo.insert!(changeset)
    result
  end
end
