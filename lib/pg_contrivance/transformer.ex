defmodule PgContrivance.Transformer do
  @moduledoc false

  def lists_to_map(columns, rows) do
    Enum.map rows, fn(r) ->
      columns
      |> Enum.zip(r)
      |> Enum.into(Map.new)
    end
  end

  def lists_to_map(columns, rows, keys: :atoms) do
    Enum.map rows, fn(r) ->
      columns
      |> Enum.zip(r)
      |> Enum.into(Map.new, fn {key, value} -> {String.to_atom(key), value} end)
    end
  end


end
