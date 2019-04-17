defmodule LineServer.IndexCreator do

  def create(file_path) do
    if File.exists?(file_path) do
      index = File.stream!(file_path)
              |> Stream.with_index
              |> Stream.map(&index_entry(&1))
              |> Stream.into(%{})

      {index, _} = Enum.map_reduce(index, 0, fn ({i, v}, acc) ->
        {{i, v + acc}, v + acc}
      end)

      if index == [] do
        {:err, :empty}
      else
        index |> Enum.into(%{0 => 0})
      end
    else
      {:err, :nofile}
    end
  end

  defp index_entry({line, line_number}) do
    {line_number + 1, byte_size(line)}
  end
end
