defmodule Kina.Parser do
  @spec parse(any, Kina.type()) :: any
  def parse(nil, _type), do: nil

  def parse(value, :integer) when is_integer(value), do: value
  def parse(value, :integer), do: value_error(value, :integer)
  def parse(value, :float) when is_float(value), do: value
  def parse(value, :float) when is_integer(value), do: value / 1
  def parse(value, :float), do: value_error(value, :float)
  def parse(value, :string) when is_binary(value), do: value
  def parse(value, :string), do: value_error(value, :string)

  def parse(value, type) do
    cond do
      not is_atom(type) ->
        type_error(type)

      Kina.Schema.kina_schema?(type) ->
        parse_schema(value, type)

      true ->
        type_error(type)
    end
  end

  @spec parse_schema(any, atom) :: struct
  def parse_schema(value, module) do
    module.__fields__()
    |> Enum.reduce(struct(module), fn {name, type, _opts}, schema ->
      sub_value = Map.get(value, name) || Map.get(value, "#{name}")
      Map.put(schema, name, parse(sub_value, type))
    end)
  end

  defp value_error(value, type) do
    raise "Invalid value, must be type #{type}: #{inspect(value)}"
  end

  defp type_error(type) do
    raise "Invalid type: #{inspect(type)}"
  end
end
