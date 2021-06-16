defmodule Bagheera.Links.Hit do
  @moduledoc """
  Hit schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bagheera.Links.Link

  schema "hits" do
    belongs_to :link, Link

    timestamps()
  end

  @doc false
  def changeset(hit, attrs) do
    hit
    |> cast(attrs, [:link_id])
    |> foreign_key_constraint(:link_id)
  end
end
