defmodule SkipListTest do
  use ExUnit.Case
  doctest SkipList

  # test "greets the world" do
  #   assert SkipList.hello() == :world
  # end

  test "skip list search" do
    sl =
      0..18
      |> Enum.map(fn x -> %SkipList.Node{key: x, value: x * x} end)
      |> SkipList.new()

    expect = 18 * 18
    assert SkipList.search(sl, 18).value == expect
  end

  test "skip list delete" do
    sl =
      0..18
      |> Enum.map(fn x -> %SkipList.Node{key: x, value: x * x} end)
      |> SkipList.new()

    nsl = SkipList.delete(sl, 12)
    assert SkipList.search(nsl, 12) == nil
  end
end
