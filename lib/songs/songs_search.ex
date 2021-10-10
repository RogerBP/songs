defmodule SongsWeb.SongsSearch do
  def search(query) do
    q = URI.encode(query)
    response = Tesla.get("https://api.deezer.com/search?q='#{q}'")
    return_result(response)
  end

  defp return_result({:error, :invalid_uri}), do: %{artists: [], albuns: [], tracks: []}

  defp return_result({:ok, response}) do
    {:ok, map} = JSON.decode(response.body)
    dados = map["data"]
    artists = extract_artists(dados)
    albums = extract_albums(dados)
    tracks = extract_tracks(dados)
    %{artists: artists, albums: albums, tracks: tracks}
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
