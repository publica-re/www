defmodule Publicare.Types.DN do
  use Ecto.Type

  # stored internally as a map

  def type, do: :map

  defp string_dn_to_keyword_list(str) do
    Enum.map(
      String.split(str, ","),
      fn el ->
        [key, value] = String.split(el, "=", parts: 2)
        {String.to_existing_atom(key), value}
      end
    )
  end

  def cast(mp) when is_map(mp) do
    {:ok, Enum.map(mp, fn {key, value} -> {String.to_existing_atom(key), value} end)}
  end

  def cast(str) when is_bitstring(str) do
    {:ok, str |> string_dn_to_keyword_list}
  end

  def cast(val) do
    if Keyword.keyword?(val) do
      {:ok, val}
    else
      :error
    end
  end

  def load(data) when is_map(data) do
    data =
      for {key, val} <- data do
        {String.to_existing_atom(key), val}
      end

    {:ok, struct!(URI, data)}
  end

  def dump(val) do
    if Keyword.keyword?(val) do
      {:ok, Enum.into(val, %{})}
    else
      :error
    end
  end
end
