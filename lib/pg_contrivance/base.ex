defmodule PgContrivance.Base do
  @moduledoc """
  The base functions that inteface directly Postgrex.
  """

  @doc """
  Connect to postgresql using the application config connection merged with
  opts passed in.

  The application should define a :pg_contrivance config
  `config :pg_contrivance, connection: [database: "contrived"]`
  """
  def connect(opts \\ []) do
    # extensions = [{Postgrex.Extensions.JSON, library: Poison}]

    Application.get_env(:pg_contrivance, :connection)
    |> Keyword.merge(opts)
    # |> Keyword.update(:extensions, extensions, &(&1 ++ extensions))
    |> Postgrex.start_link
  end

  @doc """
  If there isn't a connection process started then one is added to the command
  """
  def query(statement, params, opts \\ []) do
    with {:ok, conn} = connect(),
    do: Postgrex.query(conn, statement, params, opts)
  end

  def query!(statement, params, opts \\ []) do
    with {:ok, conn} = connect(),
    do: Postgrex.query!(conn, statement, params, opts)
  end


  @doc """
  Executes a command for a given transaction specified with `pid`. If the execution fails,
  it will be rolled backed and the exception  caught in `Query.transaction/1` and reported back using `{:error, err}`.
  """
  # def execute(cmd, pid) when is_pid(pid) do
  #   case Postgrex.Connection.query(pid, cmd.sql, cmd.params) do
  #     {:ok, result} -> {:ok, result}
  #     {:error, err} ->
  #       Postgrex.Connection.query pid, "ROLLBACK", []
  #       #this will get caught by the transactor
  #       raise err.postgres.message
  #   end
  # end


  # def start_transaction() do
  #   {:ok, pid} = PgContrivance.Runner.connect()
  #   Postgrex.Connection.query(pid, "BEGIN;",[])
  #   pid
  # end
  #
  # def commit_and_close_transaction(pid) when is_pid(pid) do
  #   Postgrex.Connection.query(pid, "COMMIT;",[])
  #   Postgrex.Connection.stop(pid)
  # end

  @doc """
  A convenience tool for assembling large queries with multiple commands. Not used
  currently. These functions hand off to PSQL because Postgrex can't run more than
  one command per query.
  """
  def run_with_psql(sql, db \\ nil) do
    if db == nil,  do: [database: db] = Application.get_env(:pg_contrivance, :connection)
    ["-d", db, "-c", sql, "--quiet", "--set", "ON_ERROR_STOP=1", "--no-psqlrc"]
    |> call_psql
  end

  def run_file_with_psql(file, db \\ nil) do
    if db == nil,  do: [database: db] = Application.get_env(:pg_contrivance, :connection)

    ["-d", db, "-f", file, "--quiet", "--set", "ON_ERROR_STOP=1", "--no-psqlrc"]
    |> call_psql
  end

  def call_psql(args),
    do: System.cmd "psql", args
end
