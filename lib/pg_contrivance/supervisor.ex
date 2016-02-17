defmodule PgContrivance.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(_type, _args) do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    Application.get_env(:pg_contrivance, :connection) |> validate_connection_args

    children = [
      worker(PgContrivance.Postgres, [])
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end


  defp validate_connection_args, do: raise "Please specify a connection in your config"
  defp validate_connection_args(args) when is_list(args), do: args

  defp validate_connection_args(""), do: []

end
