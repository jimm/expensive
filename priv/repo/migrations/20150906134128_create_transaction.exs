defmodule Expensive.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :year, :integer
      add :month, :integer
      add :day, :integer
      add :amount, :integer
      add :description, :string
      add :type, :text
      add :check_num, :integer
      add :notes, :text
      add :category_id, references(:categories)

      timestamps
    end
    create index(:transactions, [:category_id])

  end
end
