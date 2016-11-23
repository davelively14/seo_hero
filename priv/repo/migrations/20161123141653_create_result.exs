defmodule SeoHero.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :rank, :integer
      add :domain, :string
      add :snippet, :string
      add :url, :string
      add :result_collection_id, references(:result_collections)

      timestamps
    end

    create index(:results, [:result_collection_id])
  end
end
