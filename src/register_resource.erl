%% @author Cameron Dykes <yellow5c@gmail.com>
%% @copyright 2014 author.
%% @doc register webmachine_resource.

-module(register_resource).
-export([init/1, allowed_methods/2, content_types_provided/2]).
-export([process_post/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

allowed_methods(ReqData, State) ->
    {['HEAD','POST'], ReqData, State}.

content_types_provided(ReqData, State) ->
    {[ {"application/json", to_json} ], ReqData, State}.

process_post(ReqData, State) ->
    case extract_email_and_password(ReqData) of
        {false,_} ->
            Error = mochijson:encode({struct, [
                                               {"error",
                                                "Missing required email for registration"}]}),
            {{halt, 400}, wrq:append_to_response_body(Error, ReqData), State};
        {_,false} ->
            Error = mochijson:encode({struct, [
                                               {"error",
                                                "Missing required password for registration"}]}),
            {{halt, 400}, wrq:append_to_response_body(Error, ReqData), State};
        ExtractedData ->
            WebmasterId = consilium_webmaster:insert(ExtractedData),
            Resp = mochijson:encode({struct, [ {"webmaster_id", WebmasterId} ]}),
            {true, wrq:append_to_response_body(Resp, ReqData), State}
    end.

extract_email_and_password(ReqData) ->
    {_, JsonBody} = mochijson:decode(wrq:req_body(ReqData)),
    Email = consilium_helpers:extract_value_from_json("email", JsonBody),
    Pass = consilium_helpers:extract_value_from_json("password", JsonBody),
    {Email, Pass}.
