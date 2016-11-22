defmodule SeoHero.ResultsTest do
  use SeoHero.ConnCase
  alias SeoHero.Results

  @tag :external
  test "fetch_data/0 returns 9 results" do
    results = Results.fetch_data
    assert results |> length == 9
    # assert results |> List.first |> String.length > 0
  end
end
