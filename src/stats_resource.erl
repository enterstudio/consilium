%% @author Cameron Dykes <yellow5c@gmail.com>
%% @copyright 2014 author.
%% @doc stats webmachine_resource.

-module(stats_resource).
-export([init/1, content_types_provided/2, to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, State) ->
    {[ {"application/json", to_json} ], ReqData, State}.

to_json(ReqData, State) ->
    case extract_report_values(ReqData) of
        {false,_,_} ->
            Error = mochijson:encode({struct, [
                                               {"error",
                                                "Missing required webmaster_id"}]}),
            {{halt, 400}, wrq:append_to_response_body(Error, ReqData), State};
        {WebmasterId, WidgetId, Date} ->
            {UniqueCount, RawCount, TotalSales, ReportDate} = consilium_stats:get_stats({WebmasterId, WidgetId, Date}),
            Resp = mochijson:encode({struct, [{"widget_id", WidgetId},
                                              {"unique_count", UniqueCount},
                                              {"raw_count", RawCount},
                                              {"total_sales", TotalSales},
                                              {"date", consilium_helpers:formatted_date(ReportDate)}]}),
            {true, wrq:append_to_response_body(Resp, ReqData), State}
    end.

extract_report_values(ReqData) ->
    {_, JsonBody} = mochijson:decode(wrq:req_body(ReqData)),
    WebmasterId = extract_value_from_json("webmaster_id", JsonBody),
    WidgetId = extract_value_from_json("widget_id", JsonBody),
    Date = date(),
    {WebmasterId, WidgetId, Date}.

extract_value_from_json(Key, JsonBody) ->
    case lists:keysearch(Key, 1, JsonBody) of
        {_, {_, Value}} -> Value;
        _ -> false
    end.
