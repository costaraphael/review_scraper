defmodule ReviewScraper.Reviews.HTTPClientTest do
  use ExUnit.Case, async: true

  import ReviewScraper.TestHelpers

  alias ReviewScraper.Reviews.HTTPClient

  describe "fetch_page/2" do
    test "fetches the given page, returning its contents" do
      bypass = mock_http_server()

      assert {:ok, contents} = HTTPClient.fetch_page(1, http_options(bypass))

      assert is_binary(contents)
    end

    test "returns error if the server is down" do
      assert {:error, {:http_error, :econnrefused}} =
               HTTPClient.fetch_page(1, base_url: "http://999.999.999.999")
    end

    test "returns error if the server has an error" do
      bypass = mock_failing_http_server()

      assert {:error, :internal_server_error} = HTTPClient.fetch_page(1, http_options(bypass))
    end
  end
end
