# PgContrivance

This is a small utility layer on
top of [postgrex](https://github.com/ericmj/postgrex). For a high-level database wrapper look to [Ecto](https://github.com/elixir-lang/ecto) or alternatively at [Moebius](https://github.com/robconery/moebius) which does a good job of creating a direct, easy-to-use dsl. PgContrivance looks to exploit Postgresql's capabilities without abstracting the SQL away, in fact, it pretty much revels in the glory of plain old SQL and looks to exploit Postgresql specific functionality as much as possible.

Originally, PgContrivance was thought up as an addition to Moebius, but I kept thinking that it would be best as a standalone library that was only dependent on Postgrex and useable standalone or in an Ecto app too.

Functionality:

- [x] execute sql queries with params
- [x] execute sql queries with params with transaction
- [ ] bulk insert
- [x] named parameters in query strings
- [x] eex sql templates
- [x] sql from files
- [ ] much more...


## Warning/Versions
This is very much in development and highly dependent on [postgrex](https://github.com/ericmj/postgrex). PgContrivance uses Postgrex v0.11 but as functionality evolves and changes there, it may cause breaking changes here. As time goes on, I will try to keep a feature matrix of what versions work with what version of Postgrex.

Right now I'm using a version scheme like postgrex-major.postgrex-minor-contrivance-version. i.e. 0.11.1. This is very much subject to change.


## Installation

The package is not in Hex yet, it can be used by accessing it from github:

  1. Add pg_contrivance to your list of dependencies in `mix.exs`:

        def deps do
          [{:pg_contrivance, github: "plamb/pg_contrivance"},
           {:postgrex, "~> 0.11"},
           {:poolboy, "~> 1.5"}]
        end

  2. Ensure pg_contrivance is started before your application:

        def application do
          [applications: [:poolboy, :postgrex, :pg_contrivance]]
        end

## Configuration
You'll need to have a configuration block for the database connection.

        config :pg_contrivance, MyApplication.MyDb
          connection: [database: "contrived", pool_mod: DBConnection.Poolboy]

Within the connection key you can specify any of the normal Postgrex connection options.

[Note: You will need to specify the pool_mod.]


## Basic Usage
The api utilizes a %SqlCommand{} struct to make usage a bit more Elixir like (and will be quite familiar to Moebius users) that allow us to pipeline commands and results.

```ex
sql "SELECT name, email FROM USERS"
|> query
|> to_list

sql "SELECT name, email FROM users WHERE username = $1"
|> params ["bob@acme.com"]
|> query
|> to_list
```

With named parameter conversion:

```ex
sql("SELECT name, email FROM users WHERE username = :username")
|> params(%{username: "bob@acme.com"})
|> query
|> to_list
```

Using an eex template for the sql statement.

```
sql_from_template("SELECT * FROM <%= table %> WHERE id = :id", [table: "users"])
|> params(%{id: 1})
|> query
|> to_list
```

Bulk insert from a list of lists and a list of columns.

```
columns = ["a", "b", "c"]
values = [[1,2,3],[4,5,6],[7,8,9]]
bulk_insert("table_name", columns, values)
```

## Very Low-level API
At it's most basic PgContrivance is a VERY thin wrapper around Postgrex.query, query! and transaction. All of the low-level functions take a sql string, a list of params and optionally Postgrex options (:pool_timeout, :queue, :timeout, :decode_mapper, :pool)

  ```ex
  PgContrivance.Postgres.query "SELECT name, email FROM USERS", []
  ```

See the docs for the return types. query/3 returns the same its  Postgrex counterpart: `{:ok, %Postgrex.Result{}}`
or `{:error, %Postgrex.Error{}}`. query!/3 returns `%Postgrex.Result{}` or raises raises `Postgrex.Error` if
there was an error.

Transaction incorporates a rollback mechanism if there is an error but is called just like query/3:

  ```ex
  PgContrivance.Postgres.transaction "UPDATE users SET email='bob@acme.com'", []
  ```


  ## Acknowledgements
  Initially PgContrivance steals/copies and liberally imitates concepts from [Moebius](https://github.com/robconery/moebius), particularly the Moebius.Runner and bulk-insert code (thanks [John Atten](https://github.com/xivSolutions)). If it wasn't for Rob's (both [Conery](https://github.com/robconery) and [Sullivan](https://github.com/datachomp)) and [Johnny Winn](https://github.com/nurugger07) I would have never even thought about pursing my own thoughts of how I wanted a library to work or even started to code it. Their "I can do anything" attitude is quite infectious.
