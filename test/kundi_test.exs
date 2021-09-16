defmodule KundiTest do
  use ExUnit.Case
  doctest Kundi

  test "greets the world" do
    assert Kundi.hello() == :world
  end
end
