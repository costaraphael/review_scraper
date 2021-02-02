defmodule ReviewScraper.TestHelpers do
  @moduledoc """
  Functions to avoid repetitive setup and verification code in tests.
  """

  @doc """
  Reads the contents of an asset from the `test/assets` folder.
  """
  def read_asset!(file) do
    ["test", "assets", file]
    |> Path.join()
    |> File.read!()
  end
end
