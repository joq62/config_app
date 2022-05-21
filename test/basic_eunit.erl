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
-module(basic_eunit).   
 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-include_lib("eunit/include/eunit.hrl").
-export([start/0]).

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=application:start(config_app),
    ok=apps_test(),
    ok=host_test(),
  %  ok=depl_test(),
    
    stop_test(),
    ok.

apps_test()->
    AppId="controller_app",
    GitPath="https://github.com/joq62/controller_app.git",
    true=lists:member(AppId,config:application_id_all()),
    {ok,_}=config:application_vsn(AppId),
    {ok,GitPath}=config:application_gitpath(AppId),
    {error,[eexists,"glurk"]}=config:application_vsn("glurk"),
    {error,[eexists,"glurk"]}=config:application_gitpath("glurk"),
    ok.

host_test()->

    HostId="c100",
    GlurkId="glurk",
    true=lists:member(HostId,config:host_id_all()),
    {ok,"192.168.1.100"}=config:host_local_ip(HostId),
    {ok,"joqhome.asuscomm.com"}=config:host_public_ip(HostId),
    {ok,22}=config:host_ssl_port(HostId),
    {ok,"joq62"}=config:host_uid(HostId),
    {ok,_}=config:host_passwd(HostId),
    {ok,"controller@c100"}=config:host_controller_node(HostId),
    {ok,_}=config:host_cookie(HostId),
    {ok,[{conbee,[{conbee_addr,"172.17.0.2"},{conbee_port,80},{conbee_key,_}]}]}=config:host_application_config(HostId),
    %% error
    {error,[eexists,"glurk"]}=config:host_local_ip(GlurkId),
    {error,[eexists,"glurk"]}=config:host_public_ip(GlurkId),
    {error,[eexists,"glurk"]}=config:host_ssl_port(GlurkId),
    {error,[eexists,"glurk"]}=config:host_uid(GlurkId),
    {error,[eexists,"glurk"]}=config:host_passwd(GlurkId),
    {error,[eexists,"glurk"]}=config:host_controller_node(GlurkId),
    {error,[eexists,"glurk"]}=config:host_cookie(GlurkId),
    {error,[eexists,"glurk"]}=config:host_application_config(GlurkId),
    

    ok.

depl_test()->
    io:format(" deployment all files ~p~n",[deployment:all_files()]),
    io:format(" deployment:all_info() ~p~n",[deployment:all_info()]),
   
    ok. 

stop_test()->
    init:stop().

