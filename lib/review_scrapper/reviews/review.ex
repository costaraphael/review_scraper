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
         do: find_reviews(doc)
  end

  @doc """
  Compares two reviews based on how positive they are.
  """
  def compare(%__MODULE__{} = review1, %__MODULE__{} = review2) do
    review1_score = review1.dealer_rating
    review2_score = review2.dealer_rating

    cond do
      review1_score > review2_score -> :gt
      review1_score < review2_score -> :lt
      true -> :eq
    end
  end

  defp parse_document(html_page) do
    Floki.parse_document(html_page)
  end

  defp find_reviews(doc) do
    case Floki.find(doc, "#reviews .review-entry") do
      [] -> :error
      reviews -> {:ok, Enum.map(reviews, &parse_review/1)}
    end
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

  defimpl String.Chars do
    def to_string(review) do
      """
      "#{review.title}" - #{review.author}
      Rating: #{review.dealer_rating}/50

      #{review.body}
      """
    end
  end
end
