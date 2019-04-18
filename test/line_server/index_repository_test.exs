defmodule LineServer.IndexRepositoryTest do
  use ExUnit.Case, async: true
  alias LineServer.IndexRepository, as: Subject

  @index %{0 => 0, 1 => 5, 2 => 10}
  @table_name :test

  describe "save/1" do
    test "returns :ok when the index is succesfully saved" do
      assert :ok == Subject.save(@index, @table_name)
    end
  end

  describe "lookup/1" do
    test "returns the line index for the submitted line" do
      Subject.save(@index, @table_name)
      assert {:ok, 0} == Subject.lookup(0, @table_name)
      assert {:ok, 5} == Subject.lookup(1, @table_name)
      assert {:ok, 10} == Subject.lookup(2, @table_name)
    end

    test "returns an error when the line does not exist" do
      Subject.save(@index, @table_name)
      assert {:err, :notfound} == Subject.lookup(55, @table_name)
    end
  end
end
