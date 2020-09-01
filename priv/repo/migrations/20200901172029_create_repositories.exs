defmodule Publicare.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :owner, :map
      add :name, :string
      add :description, :string
      add :website, :string
      add :avatar, :binary
      add :default_branch, :string
      add :size, :integer

      timestamps()
    end

  end
end
