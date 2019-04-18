defmodule LineServer.IndexCreatorTest do
  use ExUnit.Case, async: true
  alias LineServer.IndexCreator, as: Subject

  @basicfile "test/support/basicfile"
  @onelinefile "test/support/onelinefile"
  @emptyfile "test/support/emptyfile"

  test "returns an error if the file does not exist" do
    assert {:err, :nofile} = Subject.create("nofile")
  end

  test "returns an error if the file is empty" do
    assert {:err, :empty} = Subject.create(@emptyfile)
  end

  test "the index indexes all the lines in the file (correct length is one more than # of lines)" do
    {:ok, index} = Subject.create(@basicfile)
    assert Map.size(index) == 7
  end

  test "the last index value is the total bytes of the file contents" do
    {:ok, file} = File.read(@basicfile)
    {:ok, index} = Subject.create(@basicfile)
    assert byte_size(file) == index[Map.size(index) - 1]
  end

  test "each index line value has the total number of bytes where that line ends" do
    {:ok, index} = Subject.create(@basicfile)

    assert index[0] == 0
    assert index[1] == 1
    assert index[2] == 3
    assert index[3] == 6
    assert index[4] == 10
    assert index[5] == 15
    assert index[6] == 21
  end

  test """
  the subtraction of an index line value with the previous index line value
  equals the number of bytes of that line in the file
  """ do
    {:ok, index} = Subject.create(@basicfile)
    assert index[1] - index[0] == 1
    assert index[2] - index[1] == 2
    assert index[3] - index[2] == 3
    assert index[4] - index[3] == 4
    assert index[5] - index[4] == 5
    assert index[6] - index[5] == 6
  end

  describe "when the file has only one line" do
    test "the index only has two entries" do
      {:ok, index} = Subject.create(@onelinefile)
      assert Map.size(index) == 2
    end

    test "the last index value is the total bytes of the file contents" do
      {:ok, file} = File.read(@basicfile)
      {:ok, index} = Subject.create(@basicfile)
      assert byte_size(file) == index[Map.size(index) - 1]
   end
  end
end
