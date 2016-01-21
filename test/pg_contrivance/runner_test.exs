defmodule PgContrivance.RunnerTest do
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
    assert %Postgrex.Result{num_rows: 3} =
      query! "select id, email, first, last from users limit 3", []
  end

  # test "test a query with a date" do
  #   assert {:ok, %Postgrex.Result{num_rows: 3}} =
  #     query "select ('2014-01-01'::date - interval '23 hours');", []
  # end

# this is a test that Jose gave Rob for Moebius
#   test "linked exit will check back in the tx" do
#      {:ok, pid} = Task.start fn ->
#        transaction(fn(tx) ->
#          Task.async(fn -> raise "foo" end) |> Task.await
#        end, [])
#      end
#
#      ref = Process.monitor(pid)
#      assert_receive {:DOWN, ^ref, _, _, reason}
#      assert {:error, _} = run("SAVEPOINT foo")
#    end
# end

  test "query inside a transaction" do
    assert {:ok, %Postgrex.Result{num_rows: 3}} =
      transaction("select id, email, first, last from users LIMIT 1",[])
  end
end
