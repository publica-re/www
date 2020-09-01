require Paddle.Class.Helper

Paddle.Class.Helper.gen_class(
  Publicare.Accounts.User.Ldap.InetOrgPerson,
  fields:
    ~w(uid title displayName givenName cn sn initials description labeledURI mail jpegPhoto photo preferredLanguage mobile telephoneNumber organizationName userCertificate postalAddress postOfficeBox postalCode localityName stateOrProvinceName seeAlso userPassword)a,
  unique_identifier: :uid,
  object_classes: ["inetOrgPerson", "organizationalPerson", "person"],
  required_attributes: ~w(uid cn sn userPassword mail)a,
  location: "ou=users"
)

defmodule Api.Ldap do
  alias Api.Accounts.User

  def authenticate(uid, password) do
    Paddle.authenticate(uid, password)
  end

  def get_by_uid(uid) do
    {:ok, [user]} = Paddle.get(filter: [uid: uid])

    to_map(user)
  end

  def delete_by_uid(uid) do
    admin = Application.fetch_env!(:api, :ldap_admin)
    Paddle.authenticate(admin.user, admin.password)
    Paddle.delete(uid: uid, ou: "users")
  end

  def add_object(obj) do
    admin = Application.fetch_env!(:api, :ldap_admin)
    Paddle.authenticate(admin.user, admin.password)
    casted = struct(Api.Ldap.InetOrgPerson, obj)
    Paddle.add(casted)
  end

  def modify_by_uid(uid, changes) do
    admin = Application.fetch_env!(:api, :ldap_admin)
    Paddle.authenticate(admin.user, admin.password)
    obj = get_by_uid(uid)

    modifs =
      Enum.reduce(changes, %{}, fn {k, v}, acc ->
        case {k, obj[k], v} do
          {:userPassword, _, _} -> Map.put(acc, :replace, {k, v})
          {_, nil, nil} -> acc
          {_, nil, _} -> Map.put(acc, :add, {k, v})
          {_, _, nil} -> Map.put(acc, :delete, k)
          {_, _, _} -> Map.put(acc, :replace, {k, v})
        end
      end)

    Paddle.modify([uid: uid, ou: "users"], modifs)
  end

  def list() do
    {:ok, users} = Paddle.get(filter: [objectClass: "inetOrgPerson"])
    Enum.map(users, fn x -> to_map(x) end)
  end

  defp get_value_from_list(entry, field) do
    List.first(entry[field] || [])
  end

  def to_map(entry) do
    %{
      uid: get_value_from_list(entry, "uid"),
      title: get_value_from_list(entry, "title"),
      displayName: get_value_from_list(entry, "displayName"),
      givenName: get_value_from_list(entry, "givenName"),
      cn: get_value_from_list(entry, "cn"),
      sn: get_value_from_list(entry, "sn"),
      initials: get_value_from_list(entry, "initials"),
      description: get_value_from_list(entry, "description"),
      labeledURI: get_value_from_list(entry, "labeledURI"),
      mail: get_value_from_list(entry, "mail"),
      jpegPhoto:
        if get_value_from_list(entry, "jpegPhoto") !== nil do
          "data:image/jpeg;base64," <> Base.encode64(get_value_from_list(entry, "jpegPhoto"))
        else
          nil
        end,
      photo: get_value_from_list(entry, "photo"),
      preferredLanguage: get_value_from_list(entry, "preferredLanguage"),
      mobile: get_value_from_list(entry, "mobile"),
      telephoneNumber: get_value_from_list(entry, "telephoneNumber"),
      organizationName: get_value_from_list(entry, "organizationName"),
      userCertificate: entry["userCertificate"] || [],
      postalAddress: get_value_from_list(entry, "postalAddress"),
      postOfficeBox: get_value_from_list(entry, "postOfficeBox"),
      postalCode: get_value_from_list(entry, "postalCode"),
      localityName: get_value_from_list(entry, "localityName"),
      stateOrProvinceName: get_value_from_list(entry, "stateOrProvinceName"),
      seeAlso: get_value_from_list(entry, "seeAlso")
    }
  end

  def from_object(params) do
    %{
      uid: params["uid"],
      title: params["title"],
      cn: params["cn"],
      displayName: params["displayName"],
      givenName: params["givenName"],
      sn: params["sn"],
      initials: params["initials"],
      description: params["description"],
      labeledURI: params["labeledURI"],
      mail: params["mail"],
      jpegPhoto: params["jpegPhoto"],
      photo: params["photo"],
      preferredLanguage: params["preferredLanguage"],
      mobile: params["mobile"],
      telephoneNumber: params["telephoneNumber"],
      organizationName: params["organizationName"],
      userCertificate: params["array"],
      postalAddress: params["postalAddress"],
      postOfficeBox: params["postOfficeBox"],
      postalCode: params["postalCode"],
      localityName: params["localityName"],
      stateOrProvinceName: params["stateOrProvinceName"],
      seeAlso: params["seeAlso"],
      userPassword: make_ssha(params["userPassword"])
    }
  end

  def make_ssha(password) do
    salt = :crypto.strong_rand_bytes(256) |> Base.encode64() |> binary_part(0, 256)
    hashed = Base.encode64(:crypto.hash(:sha, password <> salt) <> salt)
    "{SSHA}" <> hashed
  end
end
