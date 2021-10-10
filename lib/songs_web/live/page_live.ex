defmodule SongsWeb.PageLive do
  use SongsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       query: "",
       loading: false,
       #  preview: false,
       #  preview_song: "Song name",
       #  preview_link: "",
       tracks: [],
       albums: [],
       artists: [],
       art_act: "active",
       alb_act: "",
       sng_act: "",
       art_tab: "show active",
       alb_tab: "",
       sng_tab: ""
     )}
  end

  @impl true
  def handle_event("search", evento, socket) do
    %{"query" => query} = evento
    send(self(), {:search, query})

    {:noreply,
     assign(socket,
       query: query,
       loading: true,
       tracks: [],
       albums: [],
       artists: [],
       art_act: "active",
       alb_act: "",
       sng_act: "",
       art_tab: "show active",
       alb_tab: "",
       sng_tab: ""
     )}
  end

  def handle_event("artist_click", evento, socket) do
    %{"art" => art_id} = evento
    send(self(), {:artist_click, art_id})

    {:noreply,
     assign(socket,
       loading: true,
       tracks: [],
       albums: [],
       artists: [],
       art_act: "",
       alb_act: "active",
       sng_act: "",
       art_tab: "",
       alb_tab: "show active",
       sng_tab: ""
     )}
  end

  def handle_event("album_click", evento, socket) do
    %{"album" => alb_id} = evento
    send(self(), {:album_click, alb_id})

    {:noreply,
     assign(socket,
       loading: true,
       tracks: [],
       albums: [],
       artists: [],
       art_act: "",
       alb_act: "",
       sng_act: "active",
       art_tab: "",
       alb_tab: "",
       sng_tab: "show active"
     )}
  end

  # def handle_event("preview_click", evento, socket) do
  #   %{"link" => link, "song" => song} = evento
  #   send(self(), {:preview_click, link, song})

  #   {:noreply,
  #    assign(socket,
  #      loading: true,
  #      preview: false,
  #      preview_song: "",
  #      preview_link: "",
  #      art_act: "",
  #      alb_act: "",
  #      sng_act: "active",
  #      art_tab: "",
  #      alb_tab: "",
  #      sng_tab: "show active"
  #    )}
  # end

  @impl true
  # def handle_info({:preview_click, link, song}, socket) do
  #   {:noreply,
  #    assign(socket,
  #      loading: false,
  #      preview: true,
  #      preview_song: song,
  #      preview_link: link
  #    )}
  # end

  def handle_info({:search, query}, socket) do
    data = SongsWeb.SongsSearch.search(query)

    {:noreply,
     assign(socket,
       loading: false,
       artists: data.artists,
       albums: data.albums,
       tracks: data.tracks
     )}
  end

  def handle_info({:artist_click, art_id}, socket) do
    data = SongsWeb.Albums.get_albums(art_id)

    {:noreply,
     assign(socket,
       loading: false,
       artists: data.artists,
       albums: data.albums
     )}
  end

  def handle_info({:album_click, alb_id}, socket) do
    data = SongsWeb.Tracks.get_tracks(alb_id)

    {:noreply,
     assign(socket,
       loading: false,
       artists: data.artists,
       albums: data.albums,
       tracks: data.tracks
     )}
  end

  # <%= if @preview do %>
  #   <div class="display-preview">
  #     <div class="card card-preview">
  #       <div class="card-body">
  #         <h3><%= @preview_song %></h3>
  #         <audio controls>
  #           <source src="<%= @preview_link %>" type="audio/mpeg">
  #         </audio>
  #       </div>
  #     </div>
  #   </div>
  # <% end %>
end
