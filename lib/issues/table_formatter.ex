defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers) do
      IO.inspect(data_by_columns)
    end
  end

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows do
        printable(row[header])
      end
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)
end

# :io.format("~10s", [<<"lol">>])
#        lol:ok
# :io.format("~-10s", [<<"lol">>])
# lol       :ok
