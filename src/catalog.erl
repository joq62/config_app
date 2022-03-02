-module(catalog).

-export([
	 all/0,
	 find/1,
	 find/2,
	 member/1,
	 member/2,
	clone/0
	]).

-define(GitCatalog,"https://github.com/joq62/catalog.git").
-define(DirCatalog,"catalog").
-define(FileCatalog,"catalog.specs").

clone()->
    os:cmd("rm -rf "++?DirCatalog),
    os:cmd("git clone "++?GitCatalog),
    ok.

all()->
    File=filename:join(?DirCatalog,?FileCatalog),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   I
	   end,
    Result.

find(Id)->
    File=filename:join(?DirCatalog,?FileCatalog),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   lists:keyfind(Id,1,I)
	   end,
    Result.    

find(Id,Vsn)->
    File=filename:join(?DirCatalog,?FileCatalog),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   case lists:keyfind(Id,1,I) of
		       {Id,VsnList,GitPath}->
			   case lists:member(Vsn,VsnList) of
			       true->
				   {Id,VsnList,GitPath};
			       false->
				   false
			   end;
		       false ->
			   false
		   end	   
	   end,
    Result.    

member(Id)->
    File=filename:join(?DirCatalog,?FileCatalog),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   lists:keymember(Id,1,I)
	   end,
    Result.    

member(Id,Vsn)->
    File=filename:join(?DirCatalog,?FileCatalog),
    Result=case file:consult(File) of
	       {error, Reason}->
		   {error, Reason};
	       {ok,I}->
		   case lists:keyfind(Id,1,I) of
		       {_Id,VsnList,_GitPath}->
			   lists:member(Vsn,VsnList);
		       false ->
			   false
		   end	   
	   end,
    Result.    
