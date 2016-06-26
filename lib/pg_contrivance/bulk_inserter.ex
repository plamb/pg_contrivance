defmodule PgContrivance.BulkInserter do
  alias PgContrivance.Runner


  def insert(values, table_name, columns) when is_list(columns) and is_list(values) do

  end

  @doc """
  Insert multiple rows at once, within a single transaction, returning the inserted records. Pass in a composite list, containing the rows  to be inserted.
  Note, the columns to be inserted are defined based on the first record in the list. All records to be inserted must adhere to the same schema.

  Example:

  ```
  data = [
    [first_name: "John", last_name: "Lennon", address: "123 Main St.", city: "Portland", state: "OR", zip: "98204"],
    [first_name: "Paul", last_name: "McCartney", address: "456 Main St.", city: "Portland", state: "OR", zip: "98204"],
    [first_name: "George", last_name: "Harrison", address: "789 Main St.", city: "Portland", state: "OR", zip: "98204"],
    [first_name: "Paul", last_name: "Starkey", address: "012 Main St.", city: "Portland", state: "OR", zip: "98204"],

  ]
  result = db(:people) |> insert(data)
  ```
  """
  #
  # def bulk_insert(%QueryCommand{} = cmd, list) when is_list(list) do
  #   # do this once and get a canonnical map for the records -
  #   column_map = list |> hd |> Keyword.keys
  #   cmd
  #   |> bulk_insert_batch(list, [], column_map)
  # end
  #
  # defp bulk_insert_batch(%QueryCommand{} = cmd, list, acc, column_map) when is_list(list) do
  #   # split the records into command batches that won't overwhelm postgres with params:
  #   # 20,000 seems to be the optimal number here. Technically you can go up to 34,464, but I think Postgrex imposes a lower limit, as I
  #   # hit a wall at 34,000, but succeeded at 30,000. Perf on 100k records is best at 20,000.
  #
  #   max_params = 20000
  #   column_count = length(column_map)
  #   max_records_per_command = div(max_params, column_count)
  #
  #   { current, next_batch } = Enum.split(list, max_records_per_command)
  #   new_cmd = bulk_insert_command(cmd, current, column_map)
  #   case next_batch do
  #     [] -> %CommandBatch{commands: Enum.reverse([new_cmd | acc])}
  #     _ -> db(cmd.table_name) |> bulk_insert_batch(next_batch, [new_cmd | acc], column_map)
  #   end
  # end
  #
  # defp bulk_insert_command(%QueryCommand{} = cmd, list, column_map) when is_list(list) do
  #   column_count = length(column_map)
  #   row_count = length(list)
  #
  #   param_list = for row <- 0..row_count-1 do
  #     list = (row * column_count + 1 .. (row * column_count) + column_count)
  #       |> Enum.to_list
  #       |> Enum.map_join(",", &"$#{&1}")
  #     "(#{list})"
  #   end
  #
  #   params = for row <- list, {k, v} <- row, do: v
  #
  #   column_names = Enum.map_join(column_map,", ", &"#{&1}")
  #   value_sql = Enum.join param_list, ","
  #   sql = "insert into #{cmd.table_name}(#{column_names}) values #{value_sql};"
  #   %{cmd | sql: sql, params: params, type: :insert}
  # end


end
