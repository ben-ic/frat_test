defmodule FratTestV2Web.Graphql.Schema do
  use Absinthe.Schema
  import_types FratTestV2Web.Graphql.Schema.UserSchema

  alias FratTestV2Web.Graphql.Resolvers

  query do

    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.User.list_users/3
    end

  end

end
