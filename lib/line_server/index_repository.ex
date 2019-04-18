defmodule LineServer.IndexRepository do

  def save(index, table_name \\ :index_table) do
    :ets.new(table_name, [:set, :protected, :named_table])
    Enum.each(index, fn {k, v} ->
      :ets.insert(table_name, {k, v})
    end)
    :ok
  end

  def lookup(line_number, table_name \\ :index_table) do
    result = :ets.lookup(table_name, line_number)
    if result == [] do
      {:err, :notfound}
    else
      {:ok, result |> hd |> elem(1)}
    end
  end
end
