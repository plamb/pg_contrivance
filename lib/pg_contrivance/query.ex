defmodule PgContrivance.Query do
    alias PgContrivance.SqlCommand

    def sql(statement) when is_binary(statement),
      do: %SqlCommand{statement: statement}

    def params(%SqlCommand{} = cmd, params) when is_binary(params),
      do: %{cmd | params: params}
end
