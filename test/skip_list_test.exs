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
end
