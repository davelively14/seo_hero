defmodule SeoHero.Repo.Migrations.CreateResultCollection do
  use Ecto.Migration

  def change do
    create table(:result_collections) do
      timestamps
    end
  end
end
