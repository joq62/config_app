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
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
t0_test()->
    {ok,_}=config:start(),
    ok.

hosts1_test()->
    [controller@c200,
     controller@c201,
     controller@c202,
     controller@c203]=lists:sort(hosts:nodes_to_connect()),
    ok.



catalog_test()->
    [{"config_app",["1.0.0"],"https://github.com/joq62/config_app.git"},
     {"rb_my_divi",["1.0.0"],"https://github.com/joq62/rb_my_divi.git"}]=lists:sort(catalog:all()),

    true=catalog:member("config_app"),
    true=catalog:member("config_app","1.0.0"),
    false=catalog:member("config_app","1.0.1"),
    
    false=catalog:member("glurk"),
    false=catalog:member("glurk","1.0.0"),

    {"rb_my_divi",["1.0.0"],"https://github.com/joq62/rb_my_divi.git"}=catalog:find("rb_my_divi"),
    {"rb_my_divi",["1.0.0"],"https://github.com/joq62/rb_my_divi.git"}=catalog:find("rb_my_divi","1.0.0"),
    false=catalog:find("rb_my_divi","1.2.0"),
    
    false=catalog:find("glurk"),
    false=catalog:find("glurk","1.0.0"),
      
    ok.

deployment_test()->
    ["deployment_specs/conbee.depl",
    "deployment_specs/controller.depl"]=lists:sort(deployment:all_files()),
    [{"conbee","1.0.0","conbee_app","1.0.0",[controller@c202]},
     {"controller","1.0.0","controller_app","1.0.0",[all]}]=lists:sort(deployment:all_info()),
    
    ok.


stop_test()->
    init:stop().

