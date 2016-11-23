defmodule SeoHero.ResultCollection do
  use SeoHero.Web, :model

  schema "result_collections" do
    has_many :results, SeoHero.Result

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
