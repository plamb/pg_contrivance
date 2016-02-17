defmodule PgContrivance.Psql do
  alias PgContrivance.Postgres
  @moduledoc """
  Allows you to call command line psql with arguments of either a set of sql statements
  ad a string or a filename to pass as a parameter.

  This is a convience method copied over from Moebius.
  """

@doc """
A convenience tool for assembling large queries with multiple commands. Not used
currently. These functions hand off to PSQL because Postgrex can't run more than
one command per query.
"""
def run_with_psql(sql, db \\ nil) do
  db = db || Postgres.connection_options()[:database]
  ["-d", db, "-c", sql, "--quiet", "--set", "ON_ERROR_STOP=1", "--no-psqlrc"]
  |> call_psql
end

def run_file_with_psql(file, db \\ nil) do
  db = db || Postgres.connection_options()[:database]

  ["-d", db, "-f", file, "--quiet", "--set", "ON_ERROR_STOP=1", "--no-psqlrc"]
  |> call_psql
end

def call_psql(args),
  do: System.cmd "psql", args

end
