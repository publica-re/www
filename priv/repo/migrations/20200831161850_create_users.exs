defmodule Publicare.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :dn, :string
      add :commonName, :string
      add :surname, :string

      timestamps()
    end

  end
end
