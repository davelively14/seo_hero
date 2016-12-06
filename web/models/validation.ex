defmodule SeoHero.Validation do
  use SeoHero.Web, :model

  schema "validations" do
    field :is_valid, :boolean
    field :domain, :string

    timestamps
  end

  @required_fields ~w(is_valid domain)
  @optional_fields ~w()

  # Ensure :domain is unique and is at least 3 characters long. Could probably
  # make it more like 4, but playing it safe here.
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:domain)
    |> validate_length(:domain, min: 3)
  end
end
