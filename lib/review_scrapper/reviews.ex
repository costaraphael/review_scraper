defmodule ReviewScraper.Reviews do
  @moduledoc """
  The reviews context.

  All function related to dealing with reviews should live here.
  """

  alias ReviewScraper.Reviews.{
    BadHTTPStatusError,
    HTTPClient,
    HTTPError,
    Review,
    ReviewsParsingError
  }

  @doc """
  Returns a list of reviews.

  ### Options

    - `:pages` - the number of pages to fetch (defaults to `5`).
    - `:http_options` - options to be forwarded to the `ReviewScraper.Reviews.HTTPClient` module
    (defaults to `[]`).
  """
  def list_reviews(opts \\ []) do
    page_count = Keyword.get(opts, :pages, 5)
    http_options = Keyword.get(opts, :http_options, [])

    with {:ok, pages} <- get_pages(page_count, http_options),
         do: {:ok, List.flatten(pages)}
  end

  @doc """
  Returns the top offending reviews.

  ### Options

  Accepts the same options as the `list_reviews/1` function, with the addition of:

    - `:limit` - the number of top offending reviews to return (defaults to `3`).
  """
  def list_top_offending_reviews(opts \\ []) do
    {limit, opts} = Keyword.pop(opts, :limit, 3)

    with {:ok, reviews} <- list_reviews(opts) do
      top_offending_reviews =
        reviews
        |> Enum.sort({:desc, Review})
        |> Enum.take(limit)

      {:ok, top_offending_reviews}
    end
  end

  defp get_pages(page_count, http_options) do
    1..page_count
    |> Task.async_stream(
      fn page_number ->
        with {:ok, body} <- fetch_page(page_number, http_options),
             {:ok, page} <- parse_reviews(page_number, body),
             do: {:ok, page}
      end,
      timeout: 10_000
    )
    |> Enum.map(fn {:ok, result} -> result end)
    |> Enum.reduce_while({:ok, []}, fn
      {:ok, page}, {:ok, pages} -> {:cont, {:ok, [page | pages]}}
      {:error, error}, _acc -> {:halt, {:error, error}}
    end)
  end

  defp fetch_page(page_number, http_options) do
    case HTTPClient.fetch_page(page_number, http_options) do
      {:ok, body} ->
        {:ok, body}

      {:error, {:http_error, error}} ->
        {:error, %HTTPError{page: page_number, error: error}}

      {:error, {:bad_http_status, status}} ->
        {:error, %BadHTTPStatusError{page: page_number, status: status}}
    end
  end

  defp parse_reviews(page_number, body) do
    case Review.parse_reviews(body) do
      {:ok, reviews} -> {:ok, reviews}
      :error -> {:error, %ReviewsParsingError{page: page_number}}
    end
  end
end
