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

  @doc """
  Mocks an HTTP server using `Bypass`, returning the `Bypass.t()` struct.

  Requests always succeed and the same HTML is returned.

  The request structure is sent to the calling process using the structure
  `{:request_received, conn}`, where `conn` is a `Plug.Conn.t()` struct.

  ### Accepted options

    - `:response` - string to be returned as a response (defaults to the asset "reviews_page.html").
  """
  def mock_http_server(opts \\ []) do
    bypass = Bypass.open()

    response =
      Keyword.get_lazy(opts, :response, fn ->
        read_asset!("reviews_page.html")
      end)

    test_pid = self()

    Bypass.expect(bypass, fn conn ->
      send(test_pid, {:request_received, conn})

      Plug.Conn.resp(conn, 200, response)
    end)

    bypass
  end

  @doc """
  Similar to `mock_http_server/0`, but the request always fails with status 500.
  """
  def mock_failing_http_server() do
    bypass = Bypass.open()

    test_pid = self()

    Bypass.expect(bypass, fn conn ->
      send(test_pid, {:request_received, conn})

      Plug.Conn.resp(conn, 500, "")
    end)

    bypass
  end

  @doc """
  Takes a `Bypass` struct and returns options to be used with the `ReviewScraper.Reviews.HTTPClient`
  module.
  """
  def http_options(bypass) do
    [base_url: "http://localhost:#{bypass.port}"]
  end
end
