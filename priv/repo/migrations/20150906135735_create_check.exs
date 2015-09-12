defmodule Expensive.Repo.Migrations.CreateCheck do
  use Ecto.Migration

  def change do
    create table(:checks) do
      add :amount, :integer
      add :description, :text
      add :notes, :text
      add :transaction_id, references(:transactions)
      add :category_id, references(:categories)

      timestamps
    end
    create index(:checks, [:transaction_id])
    create index(:checks, [:category_id])

  end
end
