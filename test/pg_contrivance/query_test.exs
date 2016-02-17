defmodule PgContrivance.QueryTest do
  use ExUnit.Case

  import PgContrivance.Query

  @param_query "SELECT * FROM users WHERE lname = :lname AND fname = :fname"
  @params %{id: 1234, fname: "Charlie", lname: "Brown", dog: "snoopy", adversary: "Lucy"}

  test "convert_named_params should return tuple with $1, $2 style params and list" do
    assert {"SELECT * FROM users WHERE lname = $1 AND fname = $2", ["Brown", "Charlie"]} =
      convert_named_params(@param_query, @params)
  end

end
