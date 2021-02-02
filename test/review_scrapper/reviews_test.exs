defmodule ReviewScraper.ReviewsTest do
  use ExUnit.Case, async: true

  import ReviewScraper.TestHelpers

  alias ReviewScraper.Reviews

  describe "list_reviews/1" do
    test "returns a list of reviews" do
      bypass = mock_http_server()

      assert {:ok, [%Reviews.Review{} | _] = reviews} =
               Reviews.list_reviews(pages: 1, http_options: http_options(bypass))

      assert length(reviews) == 10

      assert_received {:request_received,
                       %{request_path: "/page1/", query_params: %{"filter" => "ONLY_POSITIVE"}}}
    end

    test "allows for fetching multiple pages" do
      bypass = mock_http_server()

      assert {:ok, [%Reviews.Review{} | _] = reviews} =
               Reviews.list_reviews(pages: 3, http_options: http_options(bypass))

      assert length(reviews) == 30

      assert_received {:request_received,
                       %{request_path: "/page1/", query_params: %{"filter" => "ONLY_POSITIVE"}}}

      assert_received {:request_received,
                       %{request_path: "/page2/", query_params: %{"filter" => "ONLY_POSITIVE"}}}

      assert_received {:request_received,
                       %{request_path: "/page3/", query_params: %{"filter" => "ONLY_POSITIVE"}}}
    end

    test "returns error if the server returns an error" do
      bypass = mock_failing_http_server()

      assert {:error, {:failed_to_fetch_page, 1, :internal_server_error}} =
               Reviews.list_reviews(pages: 1, http_options: http_options(bypass))
    end

    test "returns error if the review parsing fails" do
      bypass = mock_http_server(response: "<some>bad</html>")

      assert {:error, {:failed_to_parse_page, 1}} =
               Reviews.list_reviews(pages: 1, http_options: http_options(bypass))
    end
  end
end
