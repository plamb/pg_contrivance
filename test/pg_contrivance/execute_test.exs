defmodule PgContrivance.ExecuteTest do
  use ExUnit.Case
  import PgContrivance.Base

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

end
