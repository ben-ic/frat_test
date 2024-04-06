defmodule FratTestV2Web.Graphql.Schema.UserSchema do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
    field :password, :string
  end
end
