defmodule PgContrivance.SqlCommand do
  @moduledoc """
  Struct for the query command which is piped through all the transforms
  """
  defstruct [
    statement: "",
    params: [],
    template: "",
    template_bindings: [],
    template_options: []
  ]
end
