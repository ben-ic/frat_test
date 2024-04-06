defmodule FratTestV2.MoneyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FratTestV2.Money` context.
  """

  @doc """
  Generate a invoice.
  """
  def invoice_fixture(attrs \\ %{}) do
    {:ok, invoice} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        description: "some description",
        payor_email: "some payor_email",
        status: 42
      })
      |> FratTestV2.Money.create_invoice()

    invoice
  end
end
