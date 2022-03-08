%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(config).    
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
-define(SERVER,?MODULE).
%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state, {}).



%% --------------------------------------------------------------------
%% Definitions 
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

-export([
	 %hosts
	 connect/0,
	 running/0,
	 missing/0,	 
	 nodes_to_connect/0,
	 %catalog
	 all/0,
	 find/1,
	 find/2,
	 member/1,
	 member/2,
	 % deployment
	 all_files/0,
	 all_info/0

	]).

-export([
	 ping/0,
	 start/0,
	 stop/0
	]).

%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================

%%-----------------------------------------------------------------------

%%----------------------------------------------------------------------
%% Gen server functions
start()-> gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
stop()-> gen_server:call(?SERVER, {stop},infinity).

	 %hosts
connect()->
    gen_server:call(?SERVER, {connect},infinity).
running()->
    gen_server:call(?SERVER, {running},infinity).
missing()->
    gen_server:call(?SERVER, {missing},infinity).
nodes_to_connect()->
    gen_server:call(?SERVER, {nodes_to_connect},infinity).
	 %catalog
all()->
    gen_server:call(?SERVER, {all},infinity).
find(Id)->
    gen_server:call(?SERVER, {find,Id},infinity).
find(Id,Vsn)->
   gen_server:call(?SERVER, {find,Id,Vsn},infinity).

member(Id)->
    gen_server:call(?SERVER, {member,Id},infinity).
member(Id,Vsn)->
   gen_server:call(?SERVER, {member,Id,Vsn},infinity).
	 % deployment
all_files()->
   gen_server:call(?SERVER, {all_files},infinity).
all_info()->
    gen_server:call(?SERVER, {all_info},infinity).			    

%%---------------------------------------------------------------
-spec ping()-> {atom(),node(),module()}|{atom(),term()}.
%% 
%% @doc:check if service is running
%% @param: non
%% @returns:{pong,node,module}|{badrpc,Reason}
%%
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: 
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------
init([]) ->
    ok=hosts:clone(),
    ok=deployment:clone(),
    ok=catalog:clone(),

    {ok, #state{}}.
    
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------

%% hosts
handle_call({connect},_From,State) ->
    Reply=hosts:connect(),
    {reply, Reply, State};

handle_call({running},_From,State) ->
    Reply=hosts:running(),
    {reply, Reply, State};

handle_call({missing},_From,State) ->
    Reply=hosts:missing(),
    {reply, Reply, State};

handle_call({nodes_to_connect},_From,State) ->
    Reply=hosts:nodes_to_connect(),
    {reply, Reply, State};

handle_call({all},_From,State) ->
    Reply=catalog:all(),
    {reply, Reply, State};

handle_call({find,Id},_From,State) ->
    Reply=catalog:find(Id),
    {reply, Reply, State};

handle_call({find,Id,Vsn},_From,State) ->
    Reply=catalog:find(Id,Vsn),
    {reply, Reply, State};

handle_call({member,Id},_From,State) ->
    Reply=catalog:member(Id),
    {reply, Reply, State};

handle_call({member,Id,Vsn},_From,State) ->
    Reply=catalog:member(Id,Vsn),
    {reply, Reply, State};

handle_call({all_files},_From,State) ->
    Reply=deployment:all_files(),
    {reply, Reply, State};

handle_call({all_info},_From,State) ->
    Reply=deployment:all_info(),
    {reply, Reply, State};

handle_call({ping},_From,State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call({stop}, _From, State) ->    
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% -------------------------------------------------------------------
    
handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info({Pid,divi,[A,B]}, State) ->
    Pid!{self(),A/B},
    {noreply, State};

handle_info({stop}, State) ->
    io:format("stop ~p~n",[{?MODULE,?LINE}]),
    exit(self(),normal),
    {noreply, State};

handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
