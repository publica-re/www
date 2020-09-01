defmodule Publicare.Projects.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "repositories" do
    field :avatar, :binary
    field :default_branch, :string
    field :description, :string
    field :name, :string
    field :owner, :map
    field :size, :integer
    field :website, :string

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:owner, :name, :description, :website, :avatar, :default_branch, :size])
    |> validate_required([:owner, :name, :description, :website, :avatar, :default_branch, :size])
  end
end
