defmodule PgContrivance.Postgres do
  @moduledoc """
  The base functions that inteface directly  with PostgreSQL via Postgrex.

  Uses `postgrex` for communicating to the database
  and a connection pool, such as `poolboy`.

  ## Options
  Postgres options split in different categories described
  below. All options should be given via the repository
  configuration.

  ### Compile time options

  Those options should be set in the config file and require
  recompilation in order to make an effect.

    * `:adapter` - The adapter name, in this case, `Ecto.Adapters.Postgres`
    * `:name`- The name of the Repo supervisor process
    * `:pool` - The connection pool module, defaults to `Ecto.Pools.Poolboy`
    * `:pool_timeout` - The default timeout to use on pool calls, defaults to `5000`
    * `:timeout` - The default timeout to use on queries, defaults to `15000`

  ### Connection options

    * `:hostname` - Server hostname
    * `:port` - Server port (default: 5432)
    * `:username` - Username
    * `:password` - User password
    * `:parameters` - Keyword list of connection parameters
    * `:ssl` - Set to true if ssl should be used (default: false)
    * `:ssl_opts` - A list of ssl options, see Erlang's `ssl` docs
    * `:connect_timeout` - The timeout for establishing new connections (default: 5000)
    * `:extensions` - Specify extensions to the postgres adapter
    * `:after_connect` - A `{mod, fun, args}` to be invoked after a connection is established

  ### Storage options

    * `:encoding` - the database encoding (default: "UTF8")
    * `:template` - the template to create the database from
    * `:lc_collate` - the collation order
    * `:lc_ctype` - the character classification

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

  def query(statement, params, opts \\ []) when is_binary(statement) and is_list(params) do
    Postgrex.query(@name, statement, params, opts)
  end

  def query!(statement, params, opts \\ []) when is_binary(statement) and is_list(params) do
    Postgrex.query!(@name, statement, params, opts)
  end

  def transaction(statement, params, opts \\ []) when is_binary(statement) and is_list(params) do
    case Postgrex.transaction(@name, fn(conn) -> Postgrex.query(conn, statement, params, opts) end) do
      {:ok, result} -> result
      {:error, _err} -> Postgrex.transaction(@name, fn(conn) ->
        DBConnection.rollback(conn, :oops)
        IO.puts "TRANSACTION FAILED - ROLLINGBACK"
      end)
    end
  end

end
