defmodule GalleryWeb.PageController do
  use GalleryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
