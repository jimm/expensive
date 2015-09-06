defmodule Expensive.Repo.Migrations.CreateCategoryRegex do
  use Ecto.Migration

  def change do
    create table(:category_regexes) do
      add :regex, :string
      add :category_id, references(:categories)

      timestamps
    end
    create index(:category_regexes, [:category_id])

  end
end
