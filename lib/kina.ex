defmodule Kina do
  @type type ::
          :integer
          | :float
          | :string
          | :boolean
          | {:map, type()}
          | {:list, type()}
          | atom
end
