defmodule PgContrivance.ExecuteTest do
  use ExUnit.Case
  import PgContrivance.Runner

  # setup do
  #   db(:users) |> insert(email: "flippy@test.com", first: "Flip", last: "Sullivan")
  #   {:ok, res: true}
  # end

  test "returning single returns map" do
    assert {:ok, %Postgrex.Result{num_rows: 1, rows: [[1, "rob@test.com", "Rob", "Blah"]]}} =
      query("select id, email, first, last from users limit 1", [])
  end

  test "returning multiple rows returns map list" do
    assert {:ok, %Postgrex.Result{num_rows: 3}} =
      query "select id, email, first, last from users limit 3", []
  end

  test "test a query with a date" do
    assert {:ok, %Postgrex.Result{num_rows: 3}} =
      query "select ('2014-01-01'::date - interval '23 hours')::text;", []
  end


end
