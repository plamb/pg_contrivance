defmodule PgContrivance.Runner do
  @moduledoc """
  The base functions that inteface directly Postgrex.
  """

  @name __MODULE__

  @doc """
  Connect to postgresql using the application config connection merged with
  opts passed in.

  The application should define a :pg_contrivance config
  `config :pg_contrivance, connection: [database: "contrived"]`
  """
  def start_link() do
    connection_options
    |> Postgrex.start_link()
  end

  def connection_options() do
    Application.get_env(:pg_contrivance, :connection, [])
    |> Keyword.put(:name, @name)
  end

  @doc """
  If there isn't a connection process started then one is added to the command
  """
  def query(statement, params, opts \\ []) do
    Postgrex.query(@name, statement, params, opts)
  end

  def query!(statement, params, opts \\ []) do
    Postgrex.query!(@name, statement, params, opts)
  end

end
