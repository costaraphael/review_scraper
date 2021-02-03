defmodule ReviewScraper.Reviews.ErrorsTest do
  use ExUnit.Case, async: true

  alias ReviewScraper.Reviews.{
    BadHTTPStatusError,
    HTTPError,
    ReviewsParsingError
  }

  describe "BadHTTPStatusError" do
    test "formats the error properly" do
      error = %BadHTTPStatusError{page: 1, status: :not_found}

      assert Exception.message(error) ==
               "The server returned an unexpected error when fetching page 1: 404 - Not Found"
    end
  end

  describe "HTTPError" do
    test "formats the error properly" do
      error = %HTTPError{page: 1, error: :econnrefused}

      assert Exception.message(error) ==
               "Unable to establish connection to the server while fetching page 1: :econnrefused"
    end
  end

  describe "ReviewsParsingError" do
    test "formats the error properly" do
      error = %ReviewsParsingError{page: 1}

      assert Exception.message(error) == """
             Unable to parse page 1.

             This is likely due to a problem in the server's response or a change in the page's structure.
             """
    end
  end
end
