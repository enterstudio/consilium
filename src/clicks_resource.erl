%% @author Cameron Dykes <yellow5c@gmail.com>
%% @copyright 2014 author.
%% @doc clicks webmachine_resource.

-module(clicks_resource).
-export([init/1, allowed_methods/2, content_types_provided/2]).
-export([process_post/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

allowed_methods(ReqData, State) ->
    {['HEAD','POST'], ReqData, State}.

content_types_provided(ReqData, State) ->
    {[ {"application/json", to_json} ], ReqData, State}.

process_post(ReqData, State) ->
    case extract_request_values(ReqData) of
        {false,_} ->
            Error = mochijson:encode({struct, [
                                               {"error",
                                                "Missing required webmaster_id"}]}),
            {{halt, 400}, wrq:append_to_response_body(Error, ReqData), State};
        {_,false} ->
            Error = mochijson:encode({struct, [
                                               {"error",
                                                "Missing required widget_id"}]}),
            {{halt, 400}, wrq:append_to_response_body(Error, ReqData), State};
        {WebmasterId, WidgetId} ->
            consilium_stats:track_click({WebmasterId, WidgetId}),
            Resp = mochijson:encode({struct, [ {"webmaster_id", WebmasterId} ]}),
            {true, wrq:append_to_response_body(Resp, ReqData), State}
    end.

extract_request_values(ReqData) ->
    {_, JsonBody} = mochijson:decode(wrq:req_body(ReqData)),
    WebmasterId = consilium_helpers:extract_value_from_json("webmaster_id", JsonBody),
    WidgetId = consilium_helpers:extract_value_from_json("widget_id", JsonBody),
    {WebmasterId, WidgetId}.
