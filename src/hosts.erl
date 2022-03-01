-module(hosts).

-export([
	 clone/0,
	 connect/0,
	 running/0,
	 missing/0,	 
	 nodes_to_connect/0
	]).

-define(GitHostSpecs,"https://github.com/joq62/host_specs.git").
-define(DirHostSpecs,"host_specs").
-define(FileHostSpecs,"host.specs").

clone()->
    os:cmd("rm -rf "++?DirHostSpecs),
    os:cmd("git clone "++?GitHostSpecs),
    ok.
nodes_to_connect()->
    File=filename:join(?DirHostSpecs,?FileHostSpecs),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   I
	   end,
    Result.

connect()->
    File=filename:join(?DirHostSpecs,?FileHostSpecs),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   [Vm||Vm<-I,
			pong=:=net_adm:ping(Vm)]
	   end,
    Result.

running()->
    File=filename:join(?DirHostSpecs,?FileHostSpecs),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   [Vm||Vm<-I,
			pong=:=net_adm:ping(Vm)]
	   end,
    Result.
missing()->
    File=filename:join(?DirHostSpecs,?FileHostSpecs),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   [Vm||Vm<-I,
			pang=:=net_adm:ping(Vm)]
	   end,
    Result.
		   



			
