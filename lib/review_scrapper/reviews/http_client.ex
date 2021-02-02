defmodule ReviewScraper.Reviews.HTTPClient do
  @moduledoc """
  HTTP client used to fetch review pages.
  """

  @default_base_url "https://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"

  @doc """
  Fetch a review page.
  """
  def fetch_page(page_number, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, @default_base_url)

    url = "#{base_url}/page#{page_number}/?filter=ONLY_POSITIVE"

    case Tesla.get(url) do
      {:ok, %Tesla.Env{body: body, status: status}} when status in 200..299 -> {:ok, body}
      {:ok, %Tesla.Env{status: status}} -> {:error, Plug.Conn.Status.reason_atom(status)}
      {:error, error} -> {:error, {:http_error, error}}
    end
  end
end
