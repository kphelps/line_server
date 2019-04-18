defmodule LineServer.LineRetriever do
  def retrieve(line_number) do
    with {:ok, line_start} <- LineServer.IndexRepository.lookup(line_number - 1),
         {:ok, line_end} <- LineServer.IndexRepository.lookup(line_number)
      do
        line = read_line(file_path(), line_start, line_end)
        {:ok, line}
      else
        {:err, :notfound} -> {:err, :notfound}
      end
  end

  defp read_line(fp, line_start, line_end) do
    {:ok, file} = :file.open(fp, [:read, :binary])
    :file.position(file, line_start)
    {:ok, line} = :file.read(file, line_end - line_start)
    :file.close(file)
    line
  end

  defp file_path() do
    Application.get_env(:line_server, :file_path)
  end
end
