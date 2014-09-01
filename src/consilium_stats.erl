-module(consilium_stats).
-behavior(gen_server).

-export([start_link/0, get_stats/1, track_click/1]).
-export([init/1, handle_call/3, handle_cast/2,
         handle_info/2, terminate/2, code_change/3]).

-record(stats, {webmaster_id,
                widget_id,
                uniq=1,
                raw=1,
                sales=0,
                date=date()}).

%%% Public API

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

get_stats(ReportReq) ->
    gen_server:call({global, ?MODULE}, ReportReq).

track_click(Stat) ->
    gen_server:cast({global, ?MODULE}, {track, Stat}).

%%% Private API

init([]) ->
    {ok, dict:new()}.

handle_call({WebmasterId, WidgetId, Date}, _From, Stats) ->
    Key = {WebmasterId, WidgetId, Date},
    case dict:find(Key, Stats) of
        {ok, Stat} ->
            Report = {Stat#stats.uniq,
                      Stat#stats.raw,
                      Stat#stats.sales,
                      Stat#stats.date},
            {reply, Report, Stats};
        error ->
            EmptyReport = {0,0,0,date()},
            {reply, EmptyReport, Stats}
    end.

handle_cast({track, {WebmasterId, WidgetId}}, Stats) ->
    Key = {WebmasterId, WidgetId, date()},
    NewStats = case dict:find(Key, Stats) of
                   {ok, OldStat} ->
                       Stat = #stats{webmaster_id = WebmasterId,
                                     widget_id = WidgetId,
                                     uniq = OldStat#stats.uniq,
                                     raw = OldStat#stats.raw + 1,
                                     sales = OldStat#stats.sales,
                                     date = OldStat#stats.date},
                       dict:update(Key, fun(_) -> Stat end, Stats);
                   _NotFound ->
                       Stat = #stats{webmaster_id = WebmasterId,
                                     widget_id = WidgetId},
                       dict:store(Key, Stat, Stats)
               end,
    {noreply, NewStats}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
