-module(consilium_webmaster).
-behavior(gen_server).

-export([start_link/0, insert/1]).
-export([init/1, handle_call/3, handle_cast/2,
         handle_info/2, terminate/2, code_change/3]).

-record(webmaster, {email, password}).

%%% Public API

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

insert({Email, Pass}) ->
    Webmaster = #webmaster{email=Email, password=Pass},
    gen_server:call({global, ?MODULE}, Webmaster).

%%% Private API

init([]) ->
    {ok, dict:new()}.

handle_call(Webmaster, _From, Webmasters) ->
    WebmasterId = dict:size(Webmasters) + 1,
    NewWebmasters = dict:store(WebmasterId, Webmaster, Webmasters),
    {reply, WebmasterId, NewWebmasters}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
