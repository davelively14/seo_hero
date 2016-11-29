defmodule SeoHero.Repo.Migrations.AddUrlToResultCollections do
  use Ecto.Migration

  def change do
    alter table(:result_collections) do
      add :url, :text
    end
  end
end
