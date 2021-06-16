defmodule BagheeraWeb.Schema.LinksTypes do
  @moduledoc """
  Provides GraphQL types for Links
  """

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  @desc "A shortened url"
  node object(:link) do
    @desc "Auto-generated hash for the shortened URL"
    field :hash, :string

    @desc "Destination URL"
    field :url, :string

    # @desc "All instances that a link has been viewed"
    # field :hits, :integer
  end

  connection(node_type: :link)

  @desc "Input parameters for a new link"
  input_object(:create_link_input) do
    @desc "Desired destination URL"
    field :url, non_null(:string)
  end

  input_object(:update_link_input) do
    @desc "Opaque ID of link"
    field :id, non_null(:id)

    @desc "Desired destination URL"
    field :url, :string
  end
end
