defmodule GalleryWeb.GalleryLive do
 use Phoenix.LiveView

  def mount(_session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>works</h1>
    """
  end
end
