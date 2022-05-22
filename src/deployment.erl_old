-module(deployment).

-export([
	 all_files/0,
	 all_info/0
	]).


-define(DirSpecs,"deployment_info_specs").

all_files()->
    {ok,Files}=file:list_dir(?DirSpecs),
    DeplFiles=[filename:join(?DirSpecs,Filename)||Filename<-Files,
							    ".depl"=:=filename:extension(Filename)],
    DeplFiles.    
all_info()->
    L1=[file:consult(DeplFile)||DeplFile<-all_files()],
    [Info||{ok,[Info]}<-L1].

%find(DeplId)->
    
    
