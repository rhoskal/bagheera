defmodule BagheeraWeb.Schema do
  @moduledoc """
  GraphQL schema for URL shortener
  """

  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias BagheeraWeb.Resolvers

  import_types(__MODULE__.LinksTypes)

  node interface do
    resolve_type(fn
      %Bagheera.Links.Link{}, _ ->
        :link

      _, _ ->
        nil
    end)
  end

  query do
    @desc "Get details about a link"
    field :link, type: :link do
      arg(:id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, id: :link)
      resolve(&Resolvers.Links.get_link/3)
    end

    @desc "List available links"
    connection field(:links, node_type: :link) do
      resolve(&Resolvers.Links.all_links/3)
    end
  end

  mutation do
    @desc "Create a new link"
    field :create_link, type: :link do
      arg(:input, non_null(:create_link_input))

      resolve(&Resolvers.Links.create_link/3)
    end

    @desc "Update a link"
    field :update_link, type: :link do
      arg(:input, non_null(:update_link_input))

      middleware(Absinthe.Relay.Node.ParseIDs, input: [id: :link])
      resolve(&Resolvers.Links.update_link/3)
    end

    @desc "Delete a link"
    field :delete_link, type: :link do
      arg(:id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, id: :link)
      resolve(&Resolvers.Links.delete_link/3)
    end
  end
end
