defmodule SeoHero.Repo.Migrations.CreateValidation do
  use Ecto.Migration

  def change do
    create table(:validations) do
      add :is_valid, :boolean
      add :domain, :string

      timestamps
    end

    create unique_index(:validations, [:domain])
  end
end
