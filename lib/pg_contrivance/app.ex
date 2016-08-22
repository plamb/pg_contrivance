defmodule PgContrivance.App do
  @moduledoc false

  use Application

  # taken from Ecto until I figure out if I need to do this differently
  # https://github.com/elixir-lang/ecto/blob/master/lib/ecto/application.ex
  def start(_type, _args) do
    import Supervisor.Spec

    children = [supervisor(PgContrivance.Supervisor, [])]

    opts = [strategy: :one_for_one, name: PgContrivance.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
