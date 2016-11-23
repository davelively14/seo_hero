defmodule SeoHero.ResultsTest do
  use SeoHero.ConnCase
  alias SeoHero.Results

  setup config do
    cond do
      config[:fetch_data] ->
        results = Results.fetch_data
        {:ok, results: results}
    end
  end

  @tag :external
  @tag :fetch_data
  test "fetch_data/0 returns 9 results", %{results: results} do
    assert results |> length == 9
  end

  @tag :external
  @tag :fetch_data
  test "each result from fetch_data/0 contains data", %{results: results} do
    assert results |> Enum.each(&(assert &1.domain != nil))
  end
end
