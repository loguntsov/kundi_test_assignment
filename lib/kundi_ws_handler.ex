defmodule KundiWsHandler.State do
  defstruct [:name]
end

defmodule KundiWsHandler do
  require Logger
  
  alias KundiWsHandler.State, as: State
  
  @behaviour :cowboy_websocket
  
  def send(pid, binary) when is_binary(binary) do
    Kernel.send(pid, { :send, binary })
  end
  
  def send(pid, json) when is_map(json) do
    KundiWsHandler.send(pid, JSON.encode!(json))
  end
  
  def send(binary) do
    KundiWsHandler.send(self(), binary)
  end
  
  ## WebSocket
  
  def init(req, opts) do
    { :cowboy_websocket, req, opts }
  end
  
  def websocket_init(_opts) do
    {[], %State{ name: nil }}
  end
  
  def websocket_handle({:text, "ping"}, state) do
    {[{:text, "pong"}], state }
  end
  
  def websocket_handle({:text, data}, state) do
    json = JSON.decode!(data)
    case json do
      %{ "cmd" => cmd, "params" => params } ->
        new_state = KundiWsProtocol.command(cmd, params, state)
        {[], new_state }
      _ ->
        Logger.info("Bad json: #{json}")
        {[], state }
    end
  end
  
  def websocket_handle(term, state) do
    Logger.info("WS: #{inspect(term)}")
    {[], state}
  end
  
  def websocket_info({:send, binary}, state) do
    {[{:text, binary}], state}
  end
  
  def websocket_info(_, state) do
    {[], state}
  end
  
end

