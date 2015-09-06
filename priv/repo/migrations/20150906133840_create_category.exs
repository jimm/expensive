defmodule Expensive.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :description, :string

      timestamps
    end

  end
end
