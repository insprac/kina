defmodule KinaTest do
  use ExUnit.Case
  doctest Kina

  test "greets the world" do
    assert Kina.hello() == :world
  end
end
