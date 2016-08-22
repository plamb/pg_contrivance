defmodule PgContrivance.BulkInsertTest do
  use ExUnit.Case

  import PgContrivance.BulkInserter
  # import PgContrivance.Postgres

  test "generate params and query" do
    values = [[1,2,3,4,5,6],[7,8,9,10,11,12],[13,14,15,16,17,18]]
    table = "people"
    columns = ["first_name", "last_name", "address", "city", "state", "zip"]

    expected_params = ["($1,$2,$3,$4,$5,$6)", "($7,$8,$9,$10,$11,$12)", "($13,$14,$15,$16,$17,$18)"]
    expected_values = ["(1,2,3,4,5,6)", "(7,8,9,10,11,12)","(13,14,15,16,17,18)"]
    expected_query = "INSERT INTO people (first_name, last_name, address, city, state, zip) VALUES ($1,$2,$3,$4,$5,$6)($7,$8,$9,$10,$11,$12)($13,$14,$15,$16,$17,$18);"

    assert generate_params([3], values, 6)== expected_params
    # assert encode_values(values) == expected_values
    # assert queries(values, table, columns) == expected_query
  end

  # setup do
  #   "drop table if exists people" |> run
  #
  #   "create table people (
  #     id serial primary key,
  #     first_name text not null,
  #     last_name text not null,
  #     address text null,
  #     city text null,
  #     state text null,
  #     zip text null
  #   );" |> run
  #
  #   {:ok, res: true}
  # end
  #
  # test "inserts a list of records within a transaction" do
  #   qty = 10000
  #   data = people(qty)
  #   res = db(:people) |> insert(data)
  #   assert qty == length(res)
  # end
  #
  # test "bulk insert fails as a transaction" do
  #   data = flawed_people(4)
  #   res = db(:people) |> insert(data)
  #   assert {:error, "null value in column \"first_name\" violates not-null constraint"} == res
  #   # no records were written to the db either...
  # end
  #
  # defp people(qty) do
  #   Enum.map(1..qty, &(
  #     [
  #       first_name: "FirstName #{&1}",
  #       last_name: "LastName #{&1}",
  #       address: "666 SW Pine St.",
  #       city: "Portland",
  #       state: "OR",
  #       zip: "97209"
  #     ]))
  # end
  #
  # # tests for trans failures dur to constraint violations:
  # defp flawed_people(qty) do
  #   p = Enum.reverse(people(qty - 1))
  #   flawed = [
  #     first_name: nil,
  #     last_name: nil,
  #     address: nil,
  #     city: "fucked city",
  #     state: "BumFuck",
  #     zip: "10011"
  #   ]
  #   Enum.reverse([flawed | p])
  # end

  # tests for trans failures due to malformed inputs:
  # defp flawed_people(qty) do
  #   p = Enum.reverse(people(qty - 1))
  #   flawed = [
  #     first_name: "X",
  #     last_name: "Y",
  #     address: "Z",
  #     city: "fucked city",
  #     state: "BumFuck",
  #   ]
  #   Enum.reverse([flawed | p])
  # end

end
