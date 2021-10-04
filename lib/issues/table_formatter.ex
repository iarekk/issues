defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths = widths_of(headers, data_by_columns),
         format = format_for(column_widths) do
      puts_one_line_in_columns(headers, format)
      IO.puts(separator(column_widths))
      puts_in_columns(data_by_columns, format)
    end
  end

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows do
        printable(row[header])
      end
    end
  end

  def widths_of(headers, columns) do
    phs = Enum.map(headers, &printable/1)
    cvhs = Enum.zip(phs, columns) |> Enum.map(fn {h, c} -> [h | c] end)
    for col <- cvhs, do: col |> map(&String.length/1) |> max
  end

  def format_for(column_widths) do
    map_join(column_widths, " | ", fn w -> "~-#{w}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn w -> List.duplicate("-", w) end)
  end

  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)

  def puts_one_line_in_columns(row, format) do
    :io.format(format, row)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip()
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end
end

# :io.format("~10s", ["lol"])
#        lol:ok
# :io.format("~-10s", ["lol"])
# lol       :ok
