defmodule KundiWsRegistrar do
  @moduledoc false

  @name :websocket_registrar
  @key :ws
  def child_spec() do
    Registry.child_spec(name: @name, keys: :duplicate)
  end
  
  def register() do
    Registry.register(@name, @key, nil)
  end
  
  def broadcast(data) do
    Enum.each(Registry.lookup(@name, @key), fn({ pid, _ }) ->
      KundiWsHandler.send(pid, data)
    end)
  end
  
  def broadcast(event, params) do
    KundiWsRegistrar.broadcast(KundiWsProtocol.event(event,params))
  end
  
end
