defmodule GalleryWeb.GalleryLive do
  use Phoenix.LiveView

  def mount(_session, socket) do
    socket = socket
             |> assign(:current_id, Gallery.first_id)
             |> assign(:slideshow, :stopped)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <center>
    <%= for id <- Gallery.image_ids() do %>
      <img 
        class="<%= thumb_css_class(id, @current_id) %>"
        src="<%= Gallery.thumb_url(id) %>"
      />
    <% end %>
    </center>
    <center>
    <img 
      src="<%= Gallery.image_url(@current_id) %>"
    />
    </center>
    <center>
      <button phx-click="prev"><<</button>
      <button phx-click="next">>></button>
      <%= if @slideshow == :stopped do %>
        <button phx-click="play_slideshow">play</button>
      <% else %>
        <button phx-click="stop_slideshow">stop</button>
      <% end %>
    </center>
    """
  end

  def handle_event("next", _, socket) do
    {:noreply, assign_next_id(socket)}
  end
  def handle_event("prev", _, socket) do
    {:noreply, assign_prev_id(socket)}
  end
  def handle_event("play_slideshow", _, socket) do
    {:ok, ref} = :timer.send_interval(1_000, self(), :slideshow_next)
    {:noreply, assign(socket, :slideshow, ref)}
  end
  def handle_info(:slideshow_next, socket) do
    {:noreply, assign_next_id(socket)}
  end
  def handle_event("stop_slideshow", _, socket) do
    :timer.cancel(socket.assigns.slideshow)
    {:noreply, assign(socket, :slideshow, :stopped)}
  end

  def assign_prev_id(socket) do
    assign(socket, :current_id, Gallery.prev_image_id(socket.assigns.current_id))
  end
  def assign_next_id(socket) do
    assign(socket, :current_id, Gallery.next_image_id(socket.assigns.current_id))
  end

  def thumb_css_class(thumb_id, current_id) do
    if thumb_id == current_id do
      "selected"
    else
      "unselected"
    end
  end
end
