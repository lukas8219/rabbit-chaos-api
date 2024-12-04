-module(chaos_close_channels).
-behaviour(chaos_experiment).
-include_lib("deps/rabbit_common/include/rabbit_framing.hrl").
-export([execute/1]).
-define(NON_EXISTENT_QUEUE_NAME, <<"rabbit:chaos:non-existent-queue:experiment">>). %%TODO make it possible to externalize this OR randomize better

execute(_) ->
	Channels = pg_local:get_members(rabbit_channels),
	TotalCount = length(Channels),
	ShutdownCount = ceil(TotalCount * (25/100)),
	RandomChannels = lists:sublist(lists:sort([{rand:uniform(), Chan} || Chan <- Channels]), ShutdownCount), 
	[delegate:invoke(Pid, fun(P) -> rabbit_channel:do(P, #'queue.declare'{ passive=true, queue = ?NON_EXISTENT_QUEUE_NAME }) end) || {_, Pid} <- RandomChannels],
	ok.
