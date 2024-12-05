-module(chaos_close_connections).
-behaviour(chaos_experiment).

-export([execute/1]).

execute(#{<<"percentage">> := Percentage}) when Percentage > 0 andalso Percentage =< 100 ->
    Connections = pg_local:get_members(rabbit_connections),
    TotalCount = length(Connections),
    ShutdownCount = ceil(TotalCount * (Percentage / 100)),
    RandomConnections = lists:sublist(lists:sort([{rand:uniform(), Conn} || Conn <- Connections]), ShutdownCount), 
    [delegate:invoke(Pid, {rabbit_networking, close_connection, ["Closed connection by chaos experiment"]}) || {_, Pid} <- RandomConnections],
    ok.
