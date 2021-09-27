defmodule SongsWeb.Albums do
  def get_albums(sender, evento) do
    %{"art" => id} = evento
    SongsWeb.Artists.get_artist(sender, id)
    url = "https://api.deezer.com/artist/#{id}/albums"
    result = Tesla.get(url)
    check_result(sender, result)
  end

  def get_album(sender, id) do
    url = "https://api.deezer.com/album/#{id}"
    response = Tesla.get(url)
    check_result(sender, response)
  end

  defp check_result(_sender, {:error, :invalid_uri}), do: nil

  defp check_result(sender, {:ok, response}) do
    {:ok, dados} = JSON.decode(response.body)
    check_map(sender, dados)
  end

  defp check_map(sender, %{"data" => albums_list}) do
    albums =
      Enum.map(albums_list, fn d ->
        %{
          id: d["id"],
          name: d["title"],
          img: d["cover_medium"]
        }
      end)

    send(sender, {:albums, albums})
  end

  defp check_map(sender, map) do
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

    send(sender, {:albums, albums})
    send(sender, {:artists, artists})
  end
end
