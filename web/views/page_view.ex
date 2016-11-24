defmodule SeoHero.PageView do
  use SeoHero.Web, :view

  def readable_date(dtg) do
    {_, {{year, month, day}, {hour, minute, second, _}}} = Ecto.DateTime.dump(dtg)
    "#{month}/#{day}/#{year} at #{hour}:#{minute}"
  end
end
