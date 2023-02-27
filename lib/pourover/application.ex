defmodule Pourover.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Pourover.Router, options: [port: 4000])
    ]

    opts = [strategy: :one_for_one, name: Pourover.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
