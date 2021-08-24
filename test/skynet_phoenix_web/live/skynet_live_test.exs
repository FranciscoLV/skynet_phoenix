defmodule SkynetPhoenixWeb.PageLiveTest do
  use SkynetPhoenixWeb.ConnCase

  import Phoenix.LiveViewTest

  test "Render terminators", %{conn: conn} do
    {:ok, pid} = Skynet.spawn_terminator()
    {:ok, skynet_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "#PID&lt;"
  end

  test "Kill terminators", %{conn: conn} do
    {:ok, pid} = Skynet.spawn_terminator()
    {:ok, skynet_live, disconnected_html} = live(conn, "/")
    assert pid in Skynet.list_terminators()

    skynet_live
    |> render_click("killTerminator", %{"terminator" => Kernel.to_string(pid)})

    refute pid in Skynet.list_terminators()
  end
end
