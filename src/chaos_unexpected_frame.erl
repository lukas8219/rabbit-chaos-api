-module(chaos_unexpected_frame).
-behaviour(chaos_experiment).

-export([execute/1]).

%% This forces channels to receive weird instructions and thus closing connections with unexpected frames
%% Might not work so well since this breaks communication between client/server.
%% Ex: this will stop sending messages to consumers. If you need consumers to trigger publishes, like an EDA, this might not be the best experiment.
execute(_) ->
    Channels = pg_local:get_members(rabbit_channels),
    TotalCount = length(Channels),
    ShutdownCount = ceil(TotalCount * (25 / 100)),
    RandomChannels = lists:sublist(
	lists:sort([{rand:uniform(), Chan} || Chan <- Channels]),
	ShutdownCount
	),
	[delegate:invoke(Pid, {rabbit_channel, shutdown, []}) || {_, Pid} <- RandomChannels],
	ok.
