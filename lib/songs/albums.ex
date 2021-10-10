defmodule SongsWeb.Albums do
  def get_album(id) do
    url = "https://api.deezer.com/album/#{id}"
    response = Tesla.get(url)
    return_albums(response)
  end

  def get_albums(art_id) do
    artists = SongsWeb.Artists.get_artist(art_id)
    url = "https://api.deezer.com/artist/#{art_id}/albums"
    response = Tesla.get(url)
    map = return_albums(response)
    %{albums: map.albums, artists: artists}
  end

  defp return_albums({:error, :invalid_uri}), do: %{albums: [], artists: []}

  defp return_albums({:ok, response}) do
    {:ok, dados} = JSON.decode(response.body)
    check_map(dados)
  end

  defp check_map(%{"data" => albums_list}) do
    albums =
      Enum.map(albums_list, fn d ->
        %{
          id: d["id"],
          name: d["title"],
          img: d["cover_medium"]
        }
      end)

    %{albums: albums, artists: []}
  end

  defp check_map(map) do
    artists = [
      %{
        id: map["artist"]["id"],
        name: map["artist"]["name"],
        img: map["artist"]["picture_medium"]
      }
    ]

    albums = [
      %{
        id: map["id"],
        name: map["title"],
        img: map["cover_medium"]
      }
    ]

    %{albums: albums, artists: artists}
  end
end
