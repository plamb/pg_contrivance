defmodule PgContrivance.Transformer do
  @moduledoc """
  The results that come back from Postgrex are in a `%Postgrex.Result{}` i.e.:

  ```
  {:ok, %Postgrex.Result{columns: ["id", "email", "first", "last"],
         command: :select, connection_id: 10298, num_rows: 1,
         rows: [[1, "rob@test.com", "Rob", "Blah"]]}}
  ```

  This combines the columns and rows into a list of maps, i.e.:

  ```
  to_map(...)
  [%{"id" => 1, "email" => "rob@test.com", "first" => "Rob", "last" => "Blah"}]

  to_map(..., keys: :atoms)
  [%{id: 1, email: "rob@test.com", first: "Rob", last: "Blah"}]
  ```
  """


  @doc """

  """
  def to_list(%Postgrex.Result{} = results) do
    create_list(results.columns, results.rows)
  end

  def to_list(%Postgrex.Result{} = results, keys: :atoms) do
    create_list(results.columns, results.rows, keys: :atoms)
  end


  defp create_list(columns, rows) do
    Enum.map rows, fn(r) ->
      Enum.zip(columns,r) |> Enum.into(Map.new)
    end
  end

  defp create_list(columns, rows, keys: :atoms) do
    Enum.map rows, fn(r) ->
      Enum.zip(columns,r) |> Enum.into(Map.new, fn {key, value} -> {String.to_atom(key), value} end )
    end
  end


end
