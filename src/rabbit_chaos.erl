%% This Source Code Form is subject to the terms of the Mozilla Public
%% License, v. 2.0. If a copy of the MPL was not distributed with this
%% file, You can obtain one at https://mozilla.org/MPL/2.0/.
%%
%% Copyright (c) 2007-2020 VMware, Inc. or its affiliates.  All rights reserved.
%%

-module(rabbit_chaos).

-behaviour(application).

-export([start/2, stop/1]).

start(normal, []) ->
    Dispatch = cowboy_router:compile([
        {'_', [{"/api/v1/experiments", chaos_handler, []}]}
    ]),
    cowboy:start_clear(chaos_http, [{port, 8080}], #{env => #{dispatch => Dispatch}}), % Externalize port
    rabbit_chaos_sup:start_link().

stop(_State) ->
    ok.
