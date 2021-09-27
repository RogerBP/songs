defmodule SongsWeb.Artists do
  def get_artist(sender, art_id) do
    url = "https://api.deezer.com/artist/#{art_id}"
    result = Tesla.get(url)
    check_result(sender, result)
  end

  defp check_result(sender, {:error, :invalid_uri}) do
    send(sender, {:artists, []})
  end

  defp check_result(sender, {:ok, response}) do
    {:ok, map} = JSON.decode(response.body)

    artists = [
      %{
        id: map["id"],
        name: map["name"],
        img: map["picture_medium"]
      }
    ]

    send(sender, {:artists, artists})
  end
end
