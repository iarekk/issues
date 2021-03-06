defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1, zip: 2]

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
    phs = map(headers, &printable/1)
    cvhs = zip(phs, columns) |> map(fn {h, c} -> [h | c] end)
    for col <- cvhs, do: col |> map(&String.length/1) |> max
  end

  def format_for(column_widths) do
    map_join(column_widths, " | ", fn w -> "~-#{w}s" end) <> "~n"
  end

  @doc """
  Generate the line below the column headings.
  It's a string of hyphens with the + sign where the vertical bars go.any()

  ## Example
      iex(1)> Issues.TableFormatter.separator([1,2,3])
      "--+----+----"
  """
  def separator(column_widths) do
    map_join(column_widths, "-+-", fn w -> List.duplicate("-", w) end)
  end

  @doc """
  Returns a string representation of the passed parameter.

  ## Example
      iex>Issues.TableFormatter.printable("a")
      "a"
      iex>Issues.TableFormatter.printable(99.9)
      "99.9"
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

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
