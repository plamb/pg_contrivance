defmodule PgContrivance do
  use Application

  # taken from Ecto until I figure out if I need to do this differently
  # https://github.com/elixir-lang/ecto/blob/master/lib/ecto/application.ex
  def start,  do: start(:normal, [])
  def start(type, args) do
    PgContrivance.Supervisor.start_link(type, args)
  end
end
