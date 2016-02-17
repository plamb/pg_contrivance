defmodule PgContrivance.TransformerTest do
  use ExUnit.Case
  alias PgContrivance.Transformer

  # @columns ["id", "email", "first", "last"]
  # @rows [[1, "rob@test.com", "Rob", "Blah"]]
  @results %Postgrex.Result{columns: ["id", "email", "first", "last"],
            command: :select, connection_id: 10298, num_rows: 1,
            rows: [[1, "rob@test.com", "Rob", "Blah"]]}
  @empty_results %Postgrex.Result{columns: ["id", "email", "first", "last"],
             command: :select, connection_id: 12678, num_rows: 0, rows: []}

  # test "convert columns and rows to map" do
  #   assert [%{"email" => "rob@test.com", "first" => "Rob", "id" => 1, "last" => "Blah"}] =
  #     Transformer.create_list(@columns, @rows)
  # end
  #
  # test "convert columns and rows to map with atoms" do
  #   [%{email: "rob@test.com", first: "Rob", id: 1, last: "Blah"}] =
  #     Transformer.create_list(@columns, @rows, keys: :atoms)
  # end

  test "convert results to map" do
    [%{"email" => "rob@test.com", "first" => "Rob", "id" => 1, "last" => "Blah"}] =
      Transformer.to_list(@results)
  end

  test "convert results to map with atom keys" do
    [%{email: "rob@test.com", first: "Rob", id: 1, last: "Blah"}] =
      Transformer.to_list(@results, keys: :atoms)
  end

  test "convert empty results" do
    [] = Transformer.to_list(@empty_results)
  end

end
