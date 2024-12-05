-module(chaos_handler).
-behavior(cowboy_handler).
-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
	try
		{ok, Body, Req} = cowboy_req:read_body(Req0),
        {ok, Json } = thoas:decode(Body),
        #{
            <<"experiment">> := Experiment,
            <<"metadata">> := Metadata
        } = Json,
		ChaosExperimentModule = binary_to_atom(Experiment),
		ok = ChaosExperimentModule:execute(Metadata),
		{ok, cowboy_req:reply(200, Req), State}
	catch
		Class:Reason:Stacktrace ->
            ErrorMessage = io_lib:format("Error: ~p:~p~nStacktrace: ~p~n", [Class, Reason, Stacktrace]),
            error_logger:error_msg(ErrorMessage),
            ReqWithBody = cowboy_req:set_resp_body(ErrorMessage, Req0),
            {ok, cowboy_req:reply(400, ReqWithBody), State}
	end.
