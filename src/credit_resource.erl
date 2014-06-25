%% @author Cameron Dykes <yellow5c@gmail.com>
%% @copyright 2014 author.
%% @doc credit webmachine_resource.

-module(credit_resource).
-export([init/1, content_types_provided/2, to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, State) ->
    {[ {"application/json", to_json} ], ReqData, State}.

to_json(ReqData, State) ->
    Resp = mochijson:encode({struct, [
                                        {id, 3}
                                     ]}),
    {Resp, ReqData, State}.

