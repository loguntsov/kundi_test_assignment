defmodule KundiGameServer do
  @moduledoc false

  use GenServer
  alias KundiGame, as: Game
  alias KundiGamePlayer, as: Player
  alias KundiApp, as: App
  
  @name :game
  
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end
  
  def get_game() do
    GenServer.call(@name, :get_game)
  end
  
  def move(player, old_x, old_y, new_x, new_y) do
    GenServer.call(@name, { :move, player, old_x, old_y, new_x, new_y })
  end
  
  def put(player) do
    GenServer.call(@name, { :put, player})
  end
  
  ## GenServer callbacks

  def init([]) do
    game = Game.init(App.get_env(:width), App.get_env(:height))
    {:ok, game}
  end

  def handle_call(:get_game, _from, game) do
    {:reply, game, game}
  end
  
  def handle_call({:put, player}, _from, game) do
    { x, y } = KundiGame.rand_position(game)
    KundiGame.put(game, x, y, player)
    broadcast("put", %{ player: player, x: x, y: y })
    {:reply, { x, y }, game }
  end
  
  def handle_call({ :move, player, old_x, old_y, new_x, new_y }, _from, game) do
    case Game.get(game, old_x, old_y) do
      :none -> { :reply, :error, game }
      game_player ->
        case player.name == game_player.name do
          false -> { :reply, :error, game }
          true ->
            case Game.put(game, new_x, new_y, player) do
              :ok ->
                Game.put(game, old_x, old_y, :none)
                broadcast("move",%{
                  player: player,
                  old_pos: %{ x: old_x, y: old_y },
                  new_pos: %{ x: new_x, y: new_y }
                })
                {:reply, :ok, game }
              _ -> { :reply, :occupied, game }
            end
        end
      end
  end
  
  def handle_call(_msg, _from, state) do
    {:reply, :error, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
  
  ## Private
  
  defp broadcast(event, params) do
    KundiWsRegistrar.broadcast(KundiWsProtocol.event(event,params))
  end
  
end