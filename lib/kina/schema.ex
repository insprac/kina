defmodule Kina.Schema do
  @type type :: atom | {atom, type}
  @type field :: {atom, type, Keyword.t()}

  defmacro __using__(_) do
    quote do
      import Kina.Schema
    end
  end

  defmacro schema(block) do
    quote do
      Module.register_attribute(__MODULE__, :fields, accumulate: true)

      unquote(block)

      defstruct Enum.map(@fields, fn {name, _type, opts} ->
                  {name, Keyword.get(opts, :default)}
                end)

      @spec __kina_schema__() :: true
      def __kina_schema__, do: true

      @spec __fields__() :: [Kina.Schema.field()]
      def __fields__, do: @fields
    end
  end

  defmacro field(name, type, opts \\ []) do
    quote do
      Module.put_attribute(
        __MODULE__,
        :fields,
        {unquote(name), unquote(type), unquote(opts)}
      )
    end
  end

  @spec kina_schema?(atom) :: boolean
  def kina_schema?(module) do
    function_exported?(module, :__kina_schema__, 0)
  end

  @spec parse(map, atom) :: struct
  def parse(data, schema) do
    Kina.Parser.parse(data, schema)
  end
end
