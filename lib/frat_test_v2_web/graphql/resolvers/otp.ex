defmodule FratTestV2Web.Graphql.Resolvers.Otp do

  def check_otp(_parent, _args, _resolution) do
    {:ok, %{result: "failed"}}
  end


  def otp_auth(_parent, %{result: "failed"}, _resolution) do
    {:ok, %{
      result: "failed",
      msg: "Sorry you did not pass OTP",
    }}
  end

  def otp_auth(_parent, result = %{result: "passed"}, _resolution) do
    token_with_default_plus_custom_claims = FratTestV2.Token.generate_and_sign!(result)
    {:ok, %{
      result: "passed",
      msg: "YAY",
      token: token_with_default_plus_custom_claims
    }}
  end

  def otp_auth(_parent, args, _resolution) do
    IO.inspect args
    {:error, "Result must be success or failed"}
  end

end
