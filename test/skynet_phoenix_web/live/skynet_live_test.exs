defmodule SkynetPhoenixWeb.PageLiveTest do
  use SkynetPhoenixWeb.ConnCase

  import Phoenix.LiveViewTest

  test "Render terminators", %{conn: conn} do
    IO.inspect(conn)
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Phoenix!"
    assert render(page_live) =~ "Welcome to Phoenix!"
  end
end
