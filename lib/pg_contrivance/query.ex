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
    named_param_regex = ~r/:(\w+)/i

    # do the regex and convert the results to a keyword list [:atom, string]
    m = named_param_regex
    |> Regex.scan(query) # [[":lname", "lname"], [":fname", "fname"]]
    |> Enum.map(fn([value, atom]) -> {String.to_atom(atom), value} end) # [lname: ":lname", fname: ":fname"]

    # replace the named params in the query with $1...$n
    {q, _} = Enum.reduce(m, {query, 1}, fn({_,v}, {q, i}) -> {String.replace(q, v, "$#{i}"), i + 1 } end)

    # create a list of options to be used as params
    p = Enum.map(m, fn({k,_}) -> params[k]  end)

    {q, p}
  end


end
