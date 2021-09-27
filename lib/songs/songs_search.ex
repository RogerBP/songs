defmodule SongsWeb.SongsSearch do
  def search(sender, evento) do
    # IO.inspect({:search, sender})
    %{"query" => query} = evento
    q = URI.encode(query)
    result = Tesla.get("https://api.deezer.com/search?q='#{q}'")
    check_result(sender, result)
  end

  defp check_result(sender, {:error, :invalid_uri}) do
    send(sender, {:artists, []})
  end

  defp check_result(sender, {:ok, response}) do
    {:ok, map} = JSON.decode(response.body)
    dados = map["data"]
    artists = extract_artists(dados)
    send(sender, {:artists, artists})

    albums = extract_albums(dados)
    send(sender, {:albums, albums})

    tracks = extract_tracks(dados)
    send(sender, {:tracks, tracks})
  end

  defp extract_artists(dados) do
    Enum.map(dados, fn d ->
      %{
        id: d["artist"]["id"],
        name: d["artist"]["name"],
        img: d["artist"]["picture_medium"]
      }
    end)
    |> Enum.uniq()
  end

  defp extract_albums(dados) do
    Enum.map(dados, fn d ->
      %{
        id: d["album"]["id"],
        name: d["album"]["title"],
        img: d["album"]["cover_medium"]
      }
    end)
    |> Enum.uniq()
  end

  defp extract_tracks(dados) do
    Enum.map(dados, fn d ->
      %{
        id: d["id"],
        name: d["title"],
        link: d["link"],
        preview: d["preview"]
      }
    end)
  end
end
