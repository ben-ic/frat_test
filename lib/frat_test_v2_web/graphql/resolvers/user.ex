defmodule FratTestV2Web.Graphql.Resolvers.User do
  def list_users(_parent, args, _resolution) do
    {:ok, FratTestV2.Accounts.get_user!(1)}
  end

  def find_user(_parent, %{id: id}, _resolution) do
    case FratTestV2.Accounts.get_user(id) do
      nil ->
        {:error, "User ID #{id} not found"}
      user ->
        {:ok, user}
    end
  end
end
