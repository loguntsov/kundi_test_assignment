defmodule KundiPlayer.Supervisor do
  @moduledoc false
  
  use Supervisor
  
  @name __MODULE__
  
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init([]) do
    children = []
    Supervisor.init(children, strategy: :one_for_one)
  end
  
  def start_child(player) do
    Supervisor.start_child(@name, { player.name, { KundiPlayerServer, :start_link, [ player ] }, :transient, 5000, :worker, [ KundiPlayerServer, KundiPlayer ]})
  end
end