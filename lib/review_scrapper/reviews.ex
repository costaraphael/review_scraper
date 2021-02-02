defmodule ReviewScraper.Reviews do
  @moduledoc """
  The reviews context.

  All function related to dealing with reviews should live here.
  """

  alias ReviewScraper.Reviews.{HTTPClient, Review}

  @doc """
  Returns a list of reviews.

  ### Options

    - `:pages` - the number of pages to fetch.
    - `:http_options` - options to be forwarded to the `ReviewScraper.Reviews.HTTPClient` module.
  """
  def list_reviews(opts \\ []) do
    page_count = Keyword.get(opts, :pages, 5)
    http_options = Keyword.get(opts, :http_options, [])

    with {:ok, pages} <- get_pages(page_count, http_options, []),
         do: {:ok, List.flatten(pages)}
  end

  defp get_pages(0, _http_options, pages), do: {:ok, pages}

  defp get_pages(page_number, http_options, pages) do
    with {:ok, body} <- fetch_page(page_number, http_options),
         {:ok, page} <- parse_reviews(page_number, body),
         do: get_pages(page_number - 1, http_options, [page | pages])
  end

  defp fetch_page(page_number, http_options) do
    case HTTPClient.fetch_page(page_number, http_options) do
      {:ok, body} -> {:ok, body}
      {:error, error} -> {:error, {:failed_to_fetch_page, page_number, error}}
    end
  end

  defp parse_reviews(page_number, body) do
    case Review.parse_reviews(body) do
      {:ok, reviews} -> {:ok, reviews}
      :error -> {:error, {:failed_to_parse_page, page_number}}
    end
  end
end
