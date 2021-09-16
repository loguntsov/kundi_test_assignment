defmodule KundiAppSup.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      KundiWsRegistrar.child_spec(),
      KundiPlayerRegistrar.child_spec(),
      worker(KundiGameServer, [], restart: :permanent),
      supervisor(KundiPlayer.Supervisor, [], restart: :permanent)
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end