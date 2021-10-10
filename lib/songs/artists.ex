defmodule SongsWeb.Artists do
  def get_artist(art_id) do
    url = "https://api.deezer.com/artist/#{art_id}"
    response = Tesla.get(url)
    return_artists(response)
  end

  defp return_artists({:error, :invalid_uri}), do: []

  defp return_artists({:ok, response}) do
    {:ok, map} = JSON.decode(response.body)

    [
      %{
        id: map["id"],
        name: map["name"],
        img: map["picture_medium"]
      }
    ]
  end
end
