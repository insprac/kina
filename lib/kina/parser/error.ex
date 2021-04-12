defmodule Kina.Parser.Error do
  defexception [:message, :type, :value]

  @type t :: %__MODULE__{
          message: String.t(),
          type: any(),
          value: any()
        }
end
