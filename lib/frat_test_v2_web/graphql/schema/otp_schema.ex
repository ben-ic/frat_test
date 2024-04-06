defmodule FratTestV2Web.Graphql.Schema.OtpSchema do
  use Absinthe.Schema.Notation

  object :otp do
    field :result, :string
    field :msg, :string
    field :token, :string
  end
end
