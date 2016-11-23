defmodule SeoHero.Repo.Migrations.ChangeResultSnippetToText do
  use Ecto.Migration

  def change do
    alter table(:results) do
      modify :snippet, :text
    end
  end
end
