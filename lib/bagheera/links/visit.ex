defmodule Bagheera.Links.Visit do
  @moduledoc """
  Visit schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bagheera.Links.Link

  schema "visits" do
    belongs_to(:link, Link)

    timestamps()
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [:link_id])
    |> foreign_key_constraint(:link_id)
  end
end
