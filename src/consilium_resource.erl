%% @author Cameron Dykes <yellow5c@gmail.com>
%% @copyright 2014 author.
%% @doc Example webmachine_resource.

-module(consilium_resource).
-export([init/1, to_html/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

to_html(ReqData, State) ->
    {"<html><body>Hello, new world</body></html>", ReqData, State}.
