-module(consilium_helpers).

-export([formatted_date/1]).

formatted_date({Year,Month,Day}) ->
    Y = integer_to_list(Year),
    M = integer_to_list(Month),
    D = integer_to_list(Day),
    Y ++ "-" ++ M ++ "-" ++ D.
