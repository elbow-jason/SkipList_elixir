# SkipList

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `skip_list` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:skip_list, "~> 0.1.0"}
  ]
end
```

## Sample
```
iex(1)> sl = 0..13 |> Enum.reduce(SkipList.new_sl(), fn x, acc -> SkipList.insert(acc, x, x * x) end)

iex(2)> SkipList.printSL(sl)
level: 4: " => 49"
level: 3: " => 49 => 64 => 100"
level: 2: " => 9 => 49 => 64 => 100 => 144"
level: 1: " => 9 => 16 => 36 => 49 => 64 => 100 => 121 => 144"
level: 0: " => 0 => 1 => 4 => 9 => 16 => 25 => 36 => 49 => 64 => 81 => 100 => 121 => 144 => 169"

iex(3)> SkipList.search(sl, 9)
%SkipList.Node{key: 9, value: 81}
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/skip_list](https://hexdocs.pm/skip_list).

