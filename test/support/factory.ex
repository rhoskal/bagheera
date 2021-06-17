defmodule Bagheera.Factory do
  @moduledoc """
  ExMachina Factory for tests
  """

  use ExMachina.Ecto, repo: Bagheera.Repo
  import Bagheera.StringGenerator

  alias Bagheera.Links.{Hit, Link}

  def link_factory(attrs) do
    link = %Link{
      hash: unique_string(),
      url: Map.get(attrs, :url, sequence(:url, &"https://www.test#{&1}.com"))
    }

    merge_attributes(link, attrs)
  end

  def hit_factory(attrs) do
    %{link: link} = attrs

    %Hit{
      link_id: Map.get(link, :id)
    }
  end
end
