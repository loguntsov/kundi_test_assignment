defmodule KundiApp do
  use Application
  require Logger

  @moduledoc """
  Documentation for `Kundi`.
  
    This is simple test assigment
    Author is Sergey Loguntsov <loguntsov@gmail.com>
  """

  @doc """
  """
  
  @app :kundi
  
  def start(_start_type, _start_args) do
    dispatch = :cowboy_router.compile([
        {:_, [
              {"/", :cowboy_static, {:priv_file, :kundi, "www/index.html"}},
              {"/ws", KundiWsHandler, []},
              {"/static/[...]", :cowboy_static, {:priv_dir, :kundi, "www/static"}}
        ]}
    ])
    Logger.info("Starting application")
    {:ok, _} = :cowboy.start_clear(:http, [{:port, 8080}], %{
      :env => %{
       :dispatch => dispatch
       }
    })

    KundiAppSup.Supervisor.start_link()
  end
  
  @ doc """
    Gets environment key of application
  """
  
  def get_env(key) do
    { :ok, value } = :application.get_env(@app, key)
    value
  end
end

