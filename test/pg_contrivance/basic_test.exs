defmodule PgContrivance.BasicTest do
  use ExUnit.Case
  import PgContrivance
  #alias PgContrivance.SqlCommand

  test "basic select to list" do
    assert [%{"email" => "rob@test.com", "first" => "Rob", "last" => "Blah"},
            %{"email" => "jill@test.com", "first" => "Jill", "last" => "Gloop"},
            %{"email" => "mary@test.com", "first" => "Mary", "last" => "Muggtler"},
            %{"email" => "mike@test.com", "first" => "Mike", "last" => "Ghruoisl"}] =
        sql("SELECT first, last, email FROM USERS")
        |> query
        |> to_list
  end

  test "basic select to list as atoms" do
    assert [%{email: "rob@test.com", first: "Rob", last: "Blah"},
            %{email: "jill@test.com", first: "Jill", last: "Gloop"},
            %{email: "mary@test.com", first: "Mary", last: "Muggtler"},
            %{email: "mike@test.com", first: "Mike", last: "Ghruoisl"}] =
        sql("SELECT first, last, email FROM USERS")
        |> query
        |> to_list(keys: :atoms)
  end

  test "basic select with params to list" do
    assert [%{"email" => "mike@test.com", "first" => "Mike", "last" => "Ghruoisl"}] =
        sql("SELECT first, last, email FROM USERS WHERE first = $1")
        |> params(["Mike"])
        |> query
        |> to_list
  end

  @template_query "SELECT first, last, email FROM <%= table %> WHERE id = :id"
  @template_bindings [table: "users"]

  test "template query with named parameters" do
    assert [%{"email" => "rob@test.com", "first" => "Rob", "last" => "Blah"}] =
        sql_from_template(@template_query, @template_bindings)
        |> params(%{id: 1})
        |> query
        |> to_list
  end
end
