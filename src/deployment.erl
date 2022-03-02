-module(deployment).

-export([
	 all_files/0,
	 all_info/0,
	 clone/0
	]).

-define(GitDeploymentSpecs,"https://github.com/joq62/deployment_specs.git").
-define(DirDeploymentSpecs,"deployment_specs").

clone()->
    os:cmd("rm -rf "++?DirDeploymentSpecs),
    os:cmd("git clone "++?GitDeploymentSpecs),
    ok.

all_files()->
    {ok,Files}=file:list_dir(?DirDeploymentSpecs),
    DeplFiles=[filename:join(?DirDeploymentSpecs,Filename)||Filename<-Files,
							    ".depl"=:=filename:extension(Filename)],
    DeplFiles.    
all_info()->
    L1=[file:consult(DeplFile)||DeplFile<-all_files()],
    [Info||{ok,[Info]}<-L1].

%find(DeplId)->
    
    
