defmodule PgContrivance.Query do
  alias PgContrivance.SqlCommand
  alias PgContrivance.Postgres


  def query(%SqlCommand{} = cmd) do
    handle_query(cmd.statement, cmd.params)
  end

  def handle_query(statement, params) when is_map(params) do
    {s, p} = convert_named_params(statement, params)
    {:ok, results} = Postgres.query(s, p)
    results
  end

  def handle_query(statement, params) when is_list(params) do
    {:ok, results} = Postgres.query(statement, params)
    results
  end

  def convert_named_params(query, params \\ []) do
    named_param_regex = ~r/:\w+/i

    # do the regex and convert the results to a keyword list [:atom, string]
    matches = named_param_regex # "SELECT * FROM users WHERE lname = :lname AND fname = :fname"
    |> Regex.scan(query) # [[":lname"], [":fname"]]
    |> List.flatten # [":lname", ":fname"]

    # replace the named params in the query with $1...$n
    {q, _} = matches # [":lname", ":fname"]
    |> Enum.reduce({query, 1},
         fn(match, {q, i}) -> {String.replace(q, match, "$#{i}"), i + 1 } end)
         # {"SELECT * FROM users WHERE lname = $1 AND fname = $2", 3}

    # create a list of options to be used as params
    p = matches # [":lname", ":fname"]
    |> Enum.map(fn(x) -> String.strip(x, ?:) |> String.to_atom end) #[:lname, :fname]
    |> Enum.map(fn(a) -> params[a]  end)  # ["Brown", "Charlie"]

    # we're not doing any checking to see if the params count matches the
    # the number of params, basically this just lets the error get handled in
    # postgres itself

    {q, p}
  end


end
