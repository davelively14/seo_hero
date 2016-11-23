defmodule SeoHero.Result do
  use SeoHero.Web, :model

  schema "results" do
    field :rank, :integer
    field :domain, :string
    field :snippet, :string
    field :url, :string
    belongs_to :result_collection, SeoHero.ResultCollection

    timestamps
  end

  @required_fields ~w(rank domain url)
  @optional_fields ~w(snippet)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
