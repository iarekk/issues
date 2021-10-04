defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO, only: [capture_io: 1]

  import Issues.TableFormatter,
    only: [
      widths_of: 2,
      split_into_columns: 2,
      format_for: 1,
      separator: 1,
      print_table_for_columns: 2
    ]

  doctest Issues.TableFormatter

  @simple_test_data [
    [c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1 ++ c4"],
    [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
    [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
    [c1: "r4 c1", c2: "r4 long c2", c3: "r4 c3", c4: "r4 c4"]
  ]

  @headers [:c1, :c2, :c4]

  defp split_in_three_columns do
    split_into_columns(@simple_test_data, @headers)
  end

  test "check column splitting" do
    columns = split_in_three_columns()

    assert columns == [
             ["r1 c1", "r2 c1", "r3 c1", "r4 c1"],
             ["r1 c2", "r2 c2", "r3 c2", "r4 long c2"],
             ["r1 ++ c4", "r2 c4", "r3 c4", "r4 c4"]
           ]
  end

  test "test formatting" do
    assert format_for([2, 5]) == "~-2s | ~-5s~n"
  end

  test "test separator" do
    assert separator([2, 5]) == "---+------"
  end

  test "check the expected lengths" do
    lens = widths_of(["verylongheader", "h2", "h3"], split_in_three_columns())
    assert lens == [14, 10, 8]
  end

  test "prints output correctly" do
    result = capture_io(fn -> print_table_for_columns(@simple_test_data, @headers) end)

    assert result == """
           c1    | c2         | c4      
           ------+------------+---------
           r1 c1 | r1 c2      | r1 ++ c4
           r2 c1 | r2 c2      | r2 c4   
           r3 c1 | r3 c2      | r3 c4   
           r4 c1 | r4 long c2 | r4 c4   
           """
  end
end
