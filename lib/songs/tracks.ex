defmodule SongsWeb.Tracks do
  def get_tracks(alb_id) do
    albs_arts = SongsWeb.Albums.get_album(alb_id)
    url = "https://api.deezer.com/album/#{alb_id}/tracks"
    response = Tesla.get(url)
    tracks = return_tracks(response)
    %{artists: albs_arts.artists, albums: albs_arts.albums, tracks: tracks}
  end

  defp return_tracks({:error, :invalid_uri}), do: []

  defp return_tracks({:ok, response}) do
    map = JSON.decode(response.body)
    {:ok, dados} = map
    tracks_list = dados["data"]

    Enum.map(tracks_list, fn d ->
      %{
        id: d["id"],
        name: d["title"],
        link: d["link"],
        preview: d["preview"]
      }
    end)
  end
end
