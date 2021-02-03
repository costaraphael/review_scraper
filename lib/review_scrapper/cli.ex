defmodule ReviewScraper.CLI do
  @moduledoc """
  CLI interface to access the application.
  """

  alias ReviewScraper.Reviews

  @doc false
  def main(_args) do
    case Reviews.list_top_offending_reviews() do
      {:ok, reviews} -> display_reviews(reviews)
      {:error, error} -> display_error(error)
    end
  end

  defp display_reviews(reviews) do
    reviews
    |> Enum.intersperse(String.duplicate("=", 40))
    |> Enum.each(&IO.puts/1)
  end

  defp display_error(error) do
    IO.puts([
      IO.ANSI.red(),
      IO.ANSI.bright(),
      Exception.message(error),
      IO.ANSI.reset()
    ])
  end
end
