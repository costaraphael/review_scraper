defmodule ReviewScraper.Reviews.ReviewTest do
  use ExUnit.Case, async: true

  import ReviewScraper.TestHelpers

  alias ReviewScraper.Reviews.Review

  describe "parse_reviews/1" do
    setup do
      %{page_contents: read_asset!("reviews_page.html")}
    end

    test "parses reviews from an HTML page", %{page_contents: page_contents} do
      assert {:ok, reviews} = Review.parse_reviews(page_contents)

      assert [%Review{} = review | _] = reviews

      assert review.title == "AAAAAAAWESOME CUSTOMER SERVICE AND AWESOME PEOPLE!!!!..."
      assert review.author == "Wisdom n jacklyn"

      assert review.body ==
               "AAAAAAAWESOME CUSTOMER SERVICE AND AWESOME PEOPLE!!!! THEY CAN HELP LITERALLY ANYONE GET A NEWER NICER CAR!!! This is our 2nd go round with them!! Love them"

      assert review.dealer_rating == 48
    end

    test "returns an error when bad HTML is given" do
      assert :error = Review.parse_reviews("<this>is</broken>")
    end
  end
end
