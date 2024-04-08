defmodule FratTestV2Web.Graphql.Schema do
  use Absinthe.Schema
  import_types(FratTestV2Web.Graphql.Schema.{UserSchema, OtpSchema})

  alias FratTestV2Web.Graphql.Resolvers

  query do
    field :user, :user do
      arg :id, non_null(:id)
      resolve &Resolvers.User.find_user/3
    end

    field :otp, :otp do
      arg(:otp, non_null(:string))
      resolve(&Resolvers.Otp.check_otp/3)
    end
  end

  mutation do
    @desc "Pass OTP"
    field :pass_otp, type: :otp do
      arg(:result, non_null(:string))

      resolve(&Resolvers.Otp.otp_auth/3)
    end
  end
end
