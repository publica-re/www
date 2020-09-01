defmodule Publicare.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :dn, :string, primary_key: true
    field :uid, :string
    field :title, :string
    field :displayName, :string
    field :givenName, :string
    field :cn, :string
    field :sn, :string
    field :initials, :string
    field :description, :string
    field :labeledURI, :string
    field :mail, :string
    field :jpegPhoto, :binary
    field :photo, :string
    field :preferredLanguage, :string
    field :mobile, :string
    field :telephoneNumber, :string
    field :organizationName, :string
    field :userCertificate, {:array, :string}
    field :postalAddress, :string
    field :postOfficeBox, :string
    field :postalCode, :string
    field :localityName, :string
    field :stateOrProvinceName, :string
    field :seeAlso, :string
    field :userPassword, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(
      attrs,
      ~w(dn uid title displayName givenName cn sn initials description labeledURI mail photo preferredLanguage mobile telephoneNumber organizationName userCertificate postalAddress postOfficeBox postalCode localityName stateOrProvinceName seeAlso userPassword)a
    )
    |> validate_required([
      :dn
    ])
    |> unique_constraint(:uid)
  end
end
