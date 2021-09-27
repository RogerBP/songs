defmodule SongsWeb.PageLive do
  use SongsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", tracks: [], albums: [], artists: [])}
  end

  @impl true
  def handle_event("search", evento, socket) do
    SongsWeb.SongsSearch.search(self(), evento)
    {:noreply, assign(socket, tracks: [], albums: [], artists: [])}
    # {:noreply, socket}
  end

  def handle_event("artist_click", evento, socket) do
    SongsWeb.Albums.get_albums(self(), evento)
    {:noreply, assign(socket, tracks: [], albums: [], artists: [])}
    # {:noreply, socket}
  end

  def handle_event("album_click", evento, socket) do
    SongsWeb.Tracks.get_tracks(self(), evento)
    {:noreply, assign(socket, tracks: [], albums: [], artists: [])}
    # {:noreply, socket}
  end

  @impl true
  def handle_info({:artists, artists}, socket) do
    # IO.puts("handle_info artists")
    {:noreply, assign(socket, artists: artists)}
  end

  def handle_info({:albums, albums}, socket) do
    # IO.puts("handle_info albums")
    {:noreply, assign(socket, albums: albums)}
  end

  def handle_info({:tracks, tracks}, socket) do
    # IO.puts("handle_info tracks")
    {:noreply, assign(socket, tracks: tracks)}
  end
end
