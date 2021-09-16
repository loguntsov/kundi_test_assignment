defmodule KundiPlayerServer do
  @moduledoc false
  
  defstruct [:player, :x, :y, :flag ]
  alias KundiPlayerServer, as: State
  
  def start_link(player) do
    GenServer.start_link(__MODULE__, [ player ])
  end
  
  def step(pid, dx, dy) do
    GenServer.cast(pid, {:step, dx, dy })
  end
  
  def attack(pid) do
    GenServer.cast(pid, :attack)
  end
  
  def get_player(pid) do
    GenServer.call(pid, :get_player)
  end

  def change_life(_pid, 0) do
    :ok
  end
  
  def change_life(pid, delta_life) do
    GenServer.cast(pid, {:change_life, delta_life})
  end
 
  def init([player]) do
    { x, y } = KundiGameServer.put(player)
    KundiPlayerRegistrar.register(player.name)
    { :ok, %State{
      player: player,
      x: x,
      y: y,
      flag: :working
    }}
  end
  
  def handle_call(:get_player, _from, state) do
    {:reply, state.player, state }
  end
  
  def handle_call(_, _from, state) do
    {:reply, :error, state }
  end


  def handle_cast(_, state) when state.player.life <= 0 do
    { :noreply, state }
  end
  
  def handle_cast({ :step, dx, dy}, state) do
    new_x = state.x + dx
    new_y = state.y + dy
    new_state = case KundiGameServer.move(state.player, state.x, state.y, new_x, new_y) do
      :ok ->
        %{ state |
          x: new_x,
          y: new_y
        }
      _ -> state
    end
    {:noreply, new_state }
  end
  
  def handle_cast(:attack, state) do
    KundiGameServer.attack(state.player, state.x, state.y)
    {:noreply, state }
  end
  
  def handle_cast({:change_life, delta_life}, state) do
    player = state.player
    new_player = %{ player | life: player.life + delta_life }
    new_state = case KundiPlayer.is_alive(new_player) do
      true ->
        KundiWsRegistrar.broadcast("attack",%{
          player: new_player,
          x: state.x,
          y: state.y
        })
        %{ state | player: new_player }
      false ->
        KundiWsRegistrar.broadcast("dead",%{
          player: player,
          x: state.x,
          y: state.y
        })
        :erlang.send_after(KundiApp.get_env(:dead_timeout), self(), :revive)
        %{ state | player: %{ new_player | life: 0 }}
    end
    {:noreply, new_state }
  end
  
  def handle_info(:revive, state) do
    new_player = %{ state.player | life: 100 }
    KundiGameServer.clean(state.x, state.y)
    { x, y } = KundiGameServer.put(new_player)
    new_state = %{ state | x: x, y: y, player: new_player }
    { :noreply, new_state }
  end
  
  def handle_info(_, state) do
    {:noreply, state }
  end
  
  def terminate(_, state) do
    KundiGameServer.clean(state.x, state.y)
  end
end
