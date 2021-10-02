defmodule BagheeraWeb.Schema.LinkTypes do
  @moduledoc """
  Provides GraphQL types for Link
  """

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  alias Bagheera.Links

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

  @desc "A connection to a list of items"
  connection(:link, node_type: :link) do
    @desc """
    A count of the total number of objects in this connection, ignoring pagination. This allows a 
    client to fetch the first five objects by passing "5" as the argument to "first", then fetch 
    the total count so it could display "5 of 83", for example.
    """
    field :total_count, :integer do
      resolve(fn _pagination_args, _conn ->
        count = Links.total_count_of_links()
        {:ok, count}
      end)
    end

    @desc "Information to aid in pagination"
    field :page_info, non_null(:page_info) do
    end

    @desc "An edge in a connection"
    edge do
      @desc "A cursor for use in pagination"
      field :cursor, non_null(:string) do
      end

      @desc "The item at the end of the edge"
      field :node, :link do
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
