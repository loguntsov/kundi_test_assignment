defmodule KundiWsProtocol do
  require Logger
  
  @moduledoc false
  
  alias KundiWsHandler.State, as: State
  alias KundiWsHandler, as: Ws
  
  def command("set_name", %{ "name" => name }, state ) do
    game = KundiGameServer.get_game()
    board = Enum.map(KundiGame.get_board(game), fn {{x, y}, what} ->
      %{ what: what, x: x, y: y }
    end)
    Ws.send(KundiWsProtocol.event("board",%{
      width: game.width,
      height: game.height,
      els: board
    }))
    KundiWsRegistrar.register()
    case KundiPlayerRegistrar.pid(name) do
      {:ok, _pid } -> :ok
      nil ->
        player = KundiPlayer.default(name, :warior)
        KundiPlayer.Supervisor.start_child(player)
    end
    %State{ state | name: name }
  end
  
  def command("move_left", _, state) do
    KundiPlayerServer.step(pid(state), -1, 0)
    state
  end
  
  def command("move_right", _, state) do
    KundiPlayerServer.step(pid(state), 1, 0)
    state
  end

  def command("move_top", _, state) do
    KundiPlayerServer.step(pid(state), 0, -1)
    state
  end
  
  def command("move_bottom", _, state) do
    KundiPlayerServer.step(pid(state), 0, 1)
    state
  end
  
  def command("attack", _, state) do
    KundiPlayerServer.attack(pid(state))
    state
  end
  
  def command(any, params, state) do
    Logger.info("Unknown commands: #{inspect(any)} with params: #{inspect(params)} ")
    state
  end

  ## EVENTS

  def event(event, params) do
    %{
      event: event,
      params: params
    }
  end
  
  ## Private
  
  defp pid(state) do
    KundiPlayerRegistrar.pid!(state.name)
  end
  
end
