defmodule KundiApp do
  use Application
  require Logger

  @moduledoc """
  Documentation for `Kundi`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Kundi.hello()
      :world

  """
  def start(start_type, start_args) do
    dispatch = :cowboy_router.compile([
        {:_, [
              {"/", :cowboy_static, {:priv_file, :kundi, "www/index.html"}},
              {"/ws", :ws_h, []},
              {"/static/[...]", :cowboy_static, {:priv_dir, :websocket, "static"}}
        ]}
    ])
    Logger.info("Starting application")
    {:ok, _} = :cowboy.start_clear(:http, [{:port, 8080}], %{
      :env => %{
       :dispatch => dispatch
       }
    })

  end
end

