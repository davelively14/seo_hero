defmodule SeoHero.PageView do
  use SeoHero.Web, :view

  def readable_date(dtg) do
    {_, {{year, month, day}, {hour, minute, second, _}}} = Ecto.DateTime.dump(dtg)
    "#{month}/#{day}/#{year} at #{hour |> two_digit}:#{minute |> two_digit}"
  end

  # Ensures we display two place values for an integer.
  # Input: 6
  # Retunrs: "06"
  defp two_digit(number) do
    number |> Integer.to_string |> String.rjust(2, ?0)
  end
end
