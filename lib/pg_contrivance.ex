defmodule PgContrivance do

  alias PgContrivance.SqlCommand
  alias PgContrivance.Query

  @doc """
  Primary entry point to working with sql statements. Parameter placeholders can be
  either $1,$2...$n or atom format (:first, :last). When parameters are in
  atom format, a hash must be passed to the params function.

  ```ex
  sql "SELECT name, email FROM USERS"
  |> query
  |> to_list
  ```
  """

  def sql(statement) when is_binary(statement),
    do: %SqlCommand{statement: statement}

  @doc """
  Creates a sql query from an EEx template. Template bindings are passed as a
  keyword list and options can be any of the normal EEx options.

  ```ex
  sql_from_template("SELECT * FROM <%= table %> WHERE id = :id", [table: "users"])
  |> params(%{id: 1})
  ```
  """

  def sql_from_template(template, bindings \\ [], options \\ []),
    do: %SqlCommand{template: template, template_bindings: bindings, template_options: options}


  @doc """
  Parameters should either be a list of params or a map with key/value pairs
  to be used with a sql statement with named parameters.
  ```ex
  sql "SELECT name, email FROM users WHERE username = $1"
  |> params ["bob@acme.com"]
  |> query
  |> to_list

  sql("SELECT name, email FROM users WHERE username = :username")
  |> params(%{username: "bob@acme.com"})
  |> query
  |> to_list
  ```
  """

  def params(%SqlCommand{} = cmd, parameters) when is_list(parameters),
    do: %SqlCommand{cmd | params: parameters}

  def params(%SqlCommand{} = cmd, parameters) when is_map(parameters),
    do: %SqlCommand{cmd | params: parameters}


  @doc """
  This causes the query to be executed and returns an %Postgrex.Result{}
  """

  def query(%SqlCommand{} = cmd) do
    Query.query(cmd)
  end


  @doc """
  The results that come back from Postgrex are in a `%Postgrex.Result{}` struct i.e.:

  ```
  {:ok, %Postgrex.Result{columns: ["id", "email", "first", "last"],
         command: :select, connection_id: 10298, num_rows: 1,
         rows: [[1, "rob@test.com", "Rob", "Blah"]]}}
  ```

  This combines the columns and rows into a list of maps, i.e.:

  ```
  to_map(...)
  [%{"id" => 1, "email" => "rob@test.com", "first" => "Rob", "last" => "Blah"}]

  to_map(..., keys: :atoms)
  [%{id: 1, email: "rob@test.com", first: "Rob", last: "Blah"}]
  ```
  """
  def to_list(%Postgrex.Result{} = results) do
    PgContrivance.Transformer.lists_to_map(results.columns, results.rows)
  end

  def to_list(%Postgrex.Result{} = results, keys: :atoms) do
    PgContrivance.Transformer.lists_to_map(results.columns, results.rows, keys: :atoms)
  end


end
