defmodule FratTestV2Web.Graphql.Resolvers.User do

  def list_users(_parent, _args, _resolution) do
    {:ok, FratTestV2.Accounts.get_user!(1)}
  end

end
