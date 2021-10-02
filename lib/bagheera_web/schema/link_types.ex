defmodule BagheeraWeb.Schema.LinkTypes do
  @moduledoc """
  Provides GraphQL types for Link
  """

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import Absinthe.Relay.Node, only: [to_global_id: 2]

  scalar :link_id do
    description("""
    The `LinkId` custom scalar type represents a unique node identifier. The LinkId appears
    in a JSON response as a string (the same as a normal ID scalar type).
    """)

    parse(&parse_string/1)
    serialize(&to_global_id("Link", &1))
  end

  defp parse_string(%Absinthe.Blueprint.Input.String{value: value}), do: {:ok, value}
  defp parse_string(_), do: :error

  @desc "A shortened url"
  node object(:link) do
    @desc "Auto-generated hash for the shortened URL"
    field(:hash, non_null(:string))

    @desc "Number of times a link has been viewed"
    field(:visits, :integer)

    @desc "The opaque ID of the link object"
    field(:id, non_null(:link_id))

    @desc "Destination URL"
    field(:url, non_null(:string))
  end

  connection(:link, node_type: non_null(:link), non_null: true) do
    @desc "A count of the total number of objects in this connection, ignoring pagination."
    field :total_count, non_null(:integer) do
      resolve(fn _, %{source: conn} ->
        {:ok, length(conn.edges)}
      end)
    end

    edge do
      field :cursor, non_null(:string) do
      end
    end
  end

  @desc "Input parameters for a new link"
  input_object(:create_link_input) do
    @desc "Desired destination URL"
    field(:url, non_null(:string))
  end

  input_object(:update_link_input) do
    @desc "A custom scalar type in the form of an opaque id"
    field(:id, non_null(:link_id))

    @desc "Desired destination URL"
    field(:url, :string)
  end
end
