-module(my_game_app).
-behaviour(application).

-export([start/0, start/2, stop/1]).

start() ->
  reloader:start(), %Makes debugging simple...
  ok = application:start(cowboy),
  ok = ssl:start(),
  ok = inets:start(),  
  ok = application:start(my_game).

start(_StartType, _StartArgs) ->
 Dispatch = [
  {'_', [
   {[<<"account">>, email], account_handler, []}
  ]}
 ],
 {ok, _} = cowboy:start_listener(http, 100,
   cowboy_tcp_transport, [{port, 8080}],
   cowboy_http_protocol, [{dispatch, Dispatch}]
  ),
 my_game_sup:start_link().

stop(_State) -> ok.