-module(chaos_handler).
-behavior(cowboy_handler).
-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
	try
		{ok, Body, Req} = cowboy_req:read_body(Req0),
		#{
			<<"experiment">> := Experiment,
			<<"metadata">> := Metadata
		} = jiffy:decode(Body, [return_maps]),
		ChaosExperimentModule = binary_to_atom(Experiment, utf8),
		ok = ChaosExperimentModule:execute(Metadata),
		{ok, Req, State}
	catch
		Class:Reason:Stacktrace ->
            ErrorMessage = io_lib:format("Error: ~p:~p~nStacktrace: ~p~n", [Class, Reason, Stacktrace]),
            error_logger:error_msg(ErrorMessage),
            ReqWithBody = cowboy_req:set_resp_body(ErrorMessage, Req0),
            {ok, cowboy_req:reply(400, ReqWithBody), State}
	end.
