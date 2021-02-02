defmodule ReviewScraper.Reviews.Review do
  @moduledoc """
  Represents a review at https://www.dealerrater.com.
  """

  defstruct [:title, :author, :body, :dealer_rating]

  @doc """
  Parses a list of reviews from an HTML page.
  """
  def parse_reviews(html_page) do
    with {:ok, doc} <- parse_document(html_page),
         do: {:ok, find_reviews(doc)}
  end

  defp parse_document(html_page) do
    case Floki.parse_document(html_page) do
      {:ok, doc} -> {:ok, doc}
    end
  end

  defp find_reviews(doc) do
    Floki.find(doc, "#reviews .review-entry")
    |> Enum.map(&parse_review/1)
  end

  defp parse_review(doc) do
    %__MODULE__{
      title: doc |> text("h3") |> String.trim("\""),
      author: doc |> text("h3+span") |> String.trim_leading("- "),
      body: text(doc, ".review-content"),
      dealer_rating: parse_dealer_rating(doc)
    }
  end

  defp text(doc, selector) do
    doc
    |> Floki.find(selector)
    |> Floki.text()
  end

  defp parse_dealer_rating(doc) do
    doc
    |> Floki.find(".dealership-rating .rating-static:first-child")
    |> Floki.attribute("class")
    |> List.first()
    |> String.split()
    |> Enum.find(&(&1 =~ ~r/rating-\d+/))
    |> case do
      nil -> 0
      "rating-" <> rating -> String.to_integer(rating)
    end
  end
end
