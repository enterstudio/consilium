-module(consilium_helpers).

-export([formatted_date/1, extract_value_from_json/2]).

formatted_date({Year,Month,Day}) ->
    Y = integer_to_list(Year),
    M = integer_to_list(Month),
    D = integer_to_list(Day),
    Y ++ "-" ++ M ++ "-" ++ D.

extract_value_from_json(Key, JsonBody) ->
    case lists:keysearch(Key, 1, JsonBody) of
        {_, {_, Value}} -> Value;
        _ -> false
    end.
