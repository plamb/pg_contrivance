defmodule PgContrivance.BulkInserter do
  alias PgContrivance.Runner

  @max_params_in_chunk 20000

  @doc """
   Insert multiple records at once, within a single transaction, returning the
   inserted records. Pass in a list of lists containing the values to be inserted.
   All records to be inserted must adhere to the same schema and have the same
   number of values/types to insert for each entry in the list.

   See https://blog.codeship.com/speeding-up-bulk-imports-in-rails/

   ```
   [[1,2,3],[4,5,6],[7,8,9]]
   |> bulk_insert("table_name", ["a", "b", "c"])
   ```
   """
  def bulk_insert(values, table, columns) when is_list(values) and is_list(columns) do
    column_count = Enum.count(columns)

    # we want to turn the list of values into a list of chunks
    value_chunks = values |> encode_values |> chunk_list(column_count)

    # we need to know how many values in each chunk
    # then create the $1, $2... params lists based on the chunk sizes
    expanded_params = embeded_list_sizes(value_chunks)
                      |> generate_params(values, column_count)

    # turn the columns list into a string
    columns = encode_columns(columns)

    # create the query tuples [{query, params},{query, params},...] based on number of chunks
    queries = create_queries(table, columns, value_chunks)

    Postgres.bulk_insert(queries)
  end

  def chunk_list(values, column_count) do
    Enum.chunk(values, max_rows_in_batch(column_count), [])
  end

  def embeded_list_sizes(list) do
    list |> Enum.map(fn(x) -> Enum.count(x) end)
  end

  # defp prepare_query(table_name, columns) when is_list(columns) do
  # end

   # defp insert_chunk(values, table_name, columns) when is_list(values) and is_list(columns) do
    #  {current, next_batch} = Enum.split(values, max_records_per_command)
    #  new_cmd = batch_insert(cmd, current, column_map)
    #  case next_batch do
    #    [] -> %CommandBatch{commands: Enum.reverse([new_cmd | acc])}
    #    _ -> db(cmd.table_name) |> bulk_insert_batch(next_batch, [new_cmd | acc], column_map)
    #  end


    defp max_rows_in_batch(column_count) do
      # 20,000 values seems to be the optimal number here. Technically you can go up to 34,464,
      # but I think Postgrex imposes a lower limit, as I hit a wall at 34,000, but succeeded
      # at 30,000. Perf on 100k records is best at 20,000.
      max_params = @max_params_in_chunk
      max_records_per_command = div(max_params, column_count)
    end

   # ["first_name", "last_name", "address", "city", "state", "zip"]
   # becomes ["($1,$2,$3,$4,$5,$6)", "($7,$8,$9,$10,$11,$12)", "($13,$14,$15,$16,$17,$18)"]
   def generate_params(chunk_sizes, values, column_count) do
     #column_count = length(columns)
     row_count = length(values)

     Enum.map(1..row_count * column_count, fn(x) -> x end)
     |> Enum.chunk(column_count)
     |> Enum.map(fn(c) ->
          r = Enum.map_join(c, ",", &"$#{&1}")
          "(#{r})"
        end)
   end


   # [[1,2,3,4,5,6],[7,8,9,10,11,12],[13,14,15,16,17,18]]
   # becomes ["(1,2,3,4,5,6)", "(7,8,9,10,11,12)","(13,14,15,16,17,18)"]
   def encode_values(values) do
     Enum.map(values, fn(v) ->          # for each
       Enum.map_join(v, ",", &"#{&1}")  # output each value and join with comma
     end)
     |> Enum.map(fn(v) -> "(#{v})" end) # put () around each list element
   end

   def encode_columns(columns) do
     Enum.join(columns, ", ")
   end

   def create_queries(table, columns, params) do
     "INSERT INTO #{table} (#{columns}) VALUES #{params};"
   end

end
