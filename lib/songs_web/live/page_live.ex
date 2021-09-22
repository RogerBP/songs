defmodule SongsWeb.PageLive do
  use SongsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", tracks: [], albums: [], artists: [])}
  end

  @impl true
  def handle_event("search", evento, socket) do
    %{"query" => query} = evento
    q = URI.encode(query)
    result = Tesla.get("https://api.deezer.com/search?q=artist:'#{q}'")
    check_result(result, socket, query)
  end

  def handle_event("artist_click", evento, socket) do
    %{"art" => id} = evento
    url = "https://api.deezer.com/artist/#{id}/albums"
    result = Tesla.get(url)

    case result do
      {:ok, response} ->
        map = JSON.decode(response.body)
        {:ok, dados} = map
        albums_list = dados["data"]

        albums =
          Enum.map(albums_list, fn d ->
            %{
              id: d["id"],
              name: d["title"],
              img: d["cover_medium"]
            }
          end)

        {:noreply, socket |> assign(albums: albums)}

      {:error, :invalid_uri} ->
        nil
        {:noreply, assign(socket, [])}
    end
  end

  def handle_event("album_click", evento, socket) do
    %{"album" => id} = evento
    url = "https://api.deezer.com/album/#{id}/tracks"
    result = Tesla.get(url)

    case result do
      {:ok, response} ->
        map = JSON.decode(response.body)
        {:ok, dados} = map
        tracks_list = dados["data"]

        tracks =
          Enum.map(tracks_list, fn d ->
            %{
              id: d["id"],
              name: d["title"],
              link: d["link"],
              preview: d["preview"]
            }
          end)

        {:noreply, socket |> assign(tracks: tracks)}

      {:error, :invalid_uri} ->
        nil
        {:noreply, assign(socket, [])}
    end
  end

  defp check_result({:error, :invalid_uri}, socket, query) do
    {:noreply, socket |> assign(songs: [], query: query)}
  end

  defp check_result({:ok, response}, socket, query) do
    {:ok, map} = JSON.decode(response.body)
    dados = map["data"]
    # IO.inspect(dados)

    artists =
      Enum.map(dados, fn d ->
        %{
          id: d["artist"]["id"],
          name: d["artist"]["name"],
          img: d["artist"]["picture_medium"],
          link: d["artist"]["link"]
        }
      end)
      |> Enum.uniq()

    albums =
      Enum.map(dados, fn d ->
        %{
          id: d["album"]["id"],
          name: d["album"]["title"],
          img: d["album"]["cover_medium"]
        }
      end)
      |> Enum.uniq()

    tracks =
      Enum.map(dados, fn d ->
        %{
          id: d["id"],
          name: d["title"],
          link: d["link"],
          preview: d["preview"]
        }
      end)

    {:noreply,
     socket
     |> assign(
       query: query,
       artists: artists,
       albums: albums,
       tracks: tracks
     )}
  end
end
