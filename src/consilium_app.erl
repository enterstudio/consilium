%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the consilium application.

-module(consilium_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for consilium.
start(_Type, _StartArgs) ->
    consilium_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for consilium.
stop(_State) ->
    ok.
