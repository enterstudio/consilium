%% @author Cameron Dykes <yellow5c@gmail.com>
%% @copyright 2014 author.

%% @doc consilium startup code

-module(consilium).
-author('Cameron Dykes <yellow5c@gmail.com>').
-export([start/0, start_link/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
    ensure_started(inets),
    ensure_started(crypto),
    ensure_started(mochiweb),
    application:set_env(webmachine, webmachine_logger_module, 
                        webmachine_logger),
    ensure_started(webmachine),
    consilium_sup:start_link().

%% @spec start() -> ok
%% @doc Start the consilium server.
start() ->
    ensure_started(inets),
    ensure_started(crypto),
    ensure_started(mochiweb),
    application:set_env(webmachine, webmachine_logger_module, 
                        webmachine_logger),
    ensure_started(webmachine),
    application:start(consilium).

%% @spec stop() -> ok
%% @doc Stop the consilium server.
stop() ->
    Res = application:stop(consilium),
    application:stop(webmachine),
    application:stop(mochiweb),
    application:stop(crypto),
    application:stop(inets),
    Res.
