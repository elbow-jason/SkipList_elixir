defmodule SkipList do
  @moduledoc """
  skiplist implementation in elixir
  """
  alias SkipList.Node
  alias SkipList.List
  require Logger
  require Integer

  # 最大层数限制
  @max_level 10

  @type nde :: %Node{
          key: any,
          value: any
        }
  @type t :: %List{
          top_level: non_neg_integer,
          list_map: %{non_neg_integer => [nde]}
        }
  @type argt :: [nde] | none

  @doc """
  create a new skip list
  cause the top level is random, doctest is not possible
  """
  @spec new(argt) :: __MODULE__.t()
  def new(list) do
    reduce_func = fn %Node{key: key, value: value}, acc -> insert(acc, key, value) end
    list |> Enum.reduce(new(), reduce_func)
  end

  def new(),
    do: %List{
      top_level: 0,
      list_map: %{0 => []}
    }

  @doc """
  Generate a random hight level when a new element was inserted
  """
  @spec random_level() :: non_neg_integer
  def random_level() do
    r = rlevel(0)

    cond do
      r > @max_level -> @max_level
      :else -> r
    end
  end

  defp rlevel(acc) do
    # coin tossing
    case Enum.random(1..2) do
      1 -> acc
      2 -> rlevel(acc + 1)
    end
  end

  defp insert_into_list(sl, level, key, value) do
    case Map.fetch(sl.list_map, level) do
      :error ->
        # empty level, create a new level
        %List{
          top_level: sl.top_level + 1,
          list_map: Map.put(sl.list_map, level, [%Node{key: key, value: value}])
        }

      {:ok, list} ->
        # update level, add node to tail, and sort it
        # T: O(N), not good, need optimizing
        nlist =
          [%Node{key: key, value: value} | list]
          |> Enum.sort_by(fn x -> x.key end)

        %List{
          top_level: sl.top_level,
          list_map: Map.put(sl.list_map, level, nlist)
        }
    end
  end

  defp delete_from_list(sl, level, key) do
    case Map.fetch(sl.list_map, level) do
      :error ->
        raise "level not exists"

      {:ok, list} ->
        # delete key from list
        # nlist = df_list(list, key, [])
        nlist = list |> Enum.filter(fn x -> x.key != key end)

	# if (key, value) is the last item in list, rebuild the skiplist
        case length(nlist) do
          0 ->
            if level == sl.top_level do
              %List{
                top_level: sl.top_level - 1,
                list_map: Map.delete(sl.list_map, level)
              }
            else
              # rebuild
              nmap =
                (level + 1)..sl.top_level
                |> Enum.map(fn x -> {x, Map.fetch!(sl.list_map, x)} end)
                |> Enum.reduce(sl.list_map, fn {x, l}, acc -> Map.put(acc, x - 1, l) end)

              %List{
                top_level: sl.top_level - 1,
                list_map: nmap
              }
            end

          _ ->
            %List{
              top_level: sl.top_level,
              list_map: Map.put(sl.list_map, level, nlist)
            }
        end
    end
  end

  # defp df_list([h | t], key, acc) do
  #   cond do
  #     h.key < key -> df_list(t, key, [h | acc])
  #     h.key == key -> Enum.reverse(t) ++ acc
  #     :else -> Enum.reverse([h | t]) ++ acc
  #   end
  # end

  @doc """
  insert a element into skiplist
  """
  def insert(sl, key, value) do
    # 重复的不能插入
    if exists?(sl, key) do
      :error
    end

    # 更新位置标记位
    0..random_level()
    |> Enum.reduce(sl, fn x, acc -> insert_into_list(acc, x, key, value) end)
  end

  @doc """
  search element in a skiplist, if element not in skiplist, return nil
  """
  def search(sl, key), do: search(sl.list_map, key, sl.top_level)
  defp search(_, _, -1), do: nil

  defp search(lmap, key, level) do
    case Map.fetch(lmap, level) do
      :error ->
        raise "level not exists"

      {:ok, list} ->
        v = Enum.find(list, fn x -> x.key == key end)

        case v do
          nil -> search(lmap, key, level - 1)
          _ -> v
        end
    end
  end

  def exists?(sl, key), do: search(sl, key) != nil

  @doc """
  delete an element from skiplist
  """
  def delete(sl, key) do
    if not exists?(sl, key) do
      :error
    end

    # 从高往低删除
    sl.top_level..0
    |> Enum.reduce(sl, fn x, acc -> delete_from_list(acc, x, key) end)
  end

  def printSL(sl), do: printSL(sl.list_map, sl.top_level)

  defp printSL(_lmap, -1), do: IO.puts("end")

  defp printSL(lmap, level) do
    case Map.fetch(lmap, level) do
      :error ->
        raise "level not exists"

      {:ok, list} ->
        list
        |> Enum.map(fn x -> x.value end)
        |> Enum.reduce("", fn x, acc -> acc <> " => " <> Integer.to_string(x) end)
        |> IO.inspect(label: "level: #{level}")

        printSL(lmap, level - 1)
    end
  end
end
