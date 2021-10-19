defmodule Kina.Parser do
  @spec parse(any, Kina.type()) :: any
  def parse(nil, _type), do: nil

  def parse(value, :any), do: value
  def parse(value, :integer) when is_integer(value), do: value
  def parse(value, :float) when is_float(value), do: value
  def parse(value, :float) when is_integer(value), do: value / 1
  def parse(value, :string) when is_binary(value), do: value
  def parse(value, :boolean) when is_boolean(value), do: value
  def parse(value, :map) when is_map(value), do: value
  def parse(value, :list) when is_list(value), do: value
  def parse(value, :date) when is_binary(value), do: Date.from_iso8601!(value)

  def parse(value, :naive_datetime) when is_binary(value),
    do: NaiveDateTime.from_iso8601!(value)

  def parse(value, {:map, sub_type}) when is_map(value) do
    value
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {key, sub_value}, acc ->
      Map.put(acc, key, parse(sub_value, sub_type))
    end)
  end

  def parse(value, {:list, sub_type}) when is_list(value) do
    Enum.map(value, &parse(&1, sub_type))
  end

  def parse(value, type) when is_atom(type) do
    try do
      struct(type)
    catch
      _ -> nil
    end

    if Kina.Schema.kina_schema?(type) do
      parse_schema(value, type)
    else
      error(value, type)
    end
  end

  def parse(value, type) do
    error(value, type)
  end

  @spec parse_schema(any, atom) :: struct
  def parse_schema(value, module) when is_map(value) do
    module.__fields__()
    |> Enum.reduce(struct(module), fn {name, type, opts}, schema ->
      key = Keyword.get(opts, :key, name)
      sub_value = Map.get(value, key) || Map.get(value, "#{key}")
      Map.put(schema, name, parse(sub_value, type))
    end)
  end

  def parse_schema(value, module) do
    error(value, module)
  end

  defp error(value, type) do
    raise Kina.Parser.Error,
      value: value,
      type: type,
      message:
        "Failed to parse type = #{inspect(type)}, value = #{inspect(value)}"
  end
end
