defmodule ReviewScraper.Reviews.HTTPError do
  defexception [:page, :error]

  def message(%{page: page, error: error}) do
    "Unable to establish connection to the server while fetching page #{page}: #{inspect(error)}"
  end
end

defmodule ReviewScraper.Reviews.BadHTTPStatusError do
  alias Plug.Conn.Status

  defexception [:page, :status]

  def message(%{page: page, status: status}) do
    status_code = Status.code(status)

    status_description = "#{status_code} - #{Status.reason_phrase(status_code)}"

    "The server returned an unexpected error when fetching page #{page}: #{status_description}"
  end
end

defmodule ReviewScraper.Reviews.ReviewsParsingError do
  defexception [:page]

  def message(%{page: page}) do
    """
    Unable to parse page #{page}.

    This is likely due to a problem in the server's response or a change in the page's structure.
    """
  end
end
