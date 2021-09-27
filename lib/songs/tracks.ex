defmodule SongsWeb.Tracks do
  def get_tracks(sender, evento) do
    %{"album" => id} = evento
    SongsWeb.Albums.get_album(sender, id)

    url = "https://api.deezer.com/album/#{id}/tracks"
    result = Tesla.get(url)
    check_result(sender, result)

    # send(sender, {:albums, albums})
  end

  defp check_result(_sender, {:error, :invalid_uri}), do: nil

  defp check_result(sender, {:ok, response}) do
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

    send(sender, {:tracks, tracks})
  end
end
