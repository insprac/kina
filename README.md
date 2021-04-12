# Kina

Define and parse data structures.

Designed for the purpose of simplifying the process of building API clients,
but has many potential use-cases.

Inspired by Ecto schemas, changesets will potentially be added in future.

Example implementation: https://github.com/insprac/elixir_kucoin


## Installation

```elixir
def deps do
  [
    {:kina, "~> 0.1.0"}
  ]
end
```


## Usage

Define a schema and it's fields.

```elixir
defmodule MyApp.User do
  use Kina.Schema

  schema do
    field :username, :string
    field :password, :string
    field :emails, {:list, MyApp.UserEmail}
  end
end

defmodule MyApp.UserEmail do
  use Kina.Schema

  schema do
    field :email, :string
    field :verified, :boolean
  end
end
```

Parse the data coming from something like JSON.

```elixir
data = %{
  "username" => "insprac",
  "password" => "password",
  "emails" => [
    %{
      "email" => "insprac@example.nz",
      "verified" => true
    }
  ]
}

Kina.Parser.parse(data, MyApp.User)
# %MyApp.User{
#   username: "insprac",
#   password: "password",
#   emails: [
#     %MyApp.UserEmail{
#       email: "insprac@example.nz",
#       verified: true
#     }
#   ]
# }
```
