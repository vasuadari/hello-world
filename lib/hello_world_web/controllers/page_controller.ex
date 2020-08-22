defmodule HelloWorldWeb.PageController do
  use HelloWorldWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout({HelloWorldWeb.LayoutView, "empty.html"})
    |> render("index.html")
  end
end
