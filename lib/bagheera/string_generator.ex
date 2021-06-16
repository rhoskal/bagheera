defmodule Bagheera.StringGenerator do
  @moduledoc """
  Unique string generator for links.
  """

  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" |> String.codepoints()

  def unique_string(length \\ 5) do
    1..length
    |> Enum.map(fn _i -> Enum.random(@chars) end)
    |> Enum.join("")
  end
end
