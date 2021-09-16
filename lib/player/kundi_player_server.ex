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
end
