defmodule PublicareWeb.PageController do
  use PublicareWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout("app.html")
    |> assign(:conn, conn)
    |> render("index.html")
  end
end
