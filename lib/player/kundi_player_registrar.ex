defmodule KundiPlayerRegistrar do
  @moduledoc false
  
  @name :player_registrar
  
  def child_spec() do
    Registry.child_spec(name: @name, keys: :unique)
  end
  
  def get(name) do
    case Registry.lookup(@name, name) do
      [{pid, _}] -> { :ok, pid }
      [] -> :nil
    end
  end
  
  def register(name) do
    Registry.register(@name, name, :nil)
  end
end
