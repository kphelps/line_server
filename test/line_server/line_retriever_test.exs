defmodule LineServer.LineRetrieverTest do
  use ExUnit.Case, async: true
  alias LineServer.LineRetriever, as: Subject

  @doc """
  file: test/support/basicfile
  ---------

  a
  aa
  aaa
  aaaa
  aaaaa
  ---------
  """

  describe "retrieve/1" do
    test "returns the line contents for the submitted line number" do
      assert Subject.retrieve(1) == {:ok, "\n"}
      assert Subject.retrieve(2) == {:ok, "a\n"}
      assert Subject.retrieve(3) == {:ok, "aa\n"}
      assert Subject.retrieve(4) == {:ok, "aaa\n"}
      assert Subject.retrieve(5) == {:ok, "aaaa\n"}
      assert Subject.retrieve(6) == {:ok, "aaaaa\n"}
    end

    test "returns an error when the line does not exist" do
      assert Subject.retrieve(55) == {:err, :notfound}
    end
  end
end
