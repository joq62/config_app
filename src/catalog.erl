-module(catalog).

-export([
	clone/0
	]).



-define(GitCatalog,"https://github.com/joq62/catalog.git").
-define(DirCatalog,"catalog").
-define(FileCatalog,"catalog.specs").

clone()->
    os:cmd("rm -rf "++?DirCatalog),
    os:cmd("git clone "++?GitCatalog),
    ok.

