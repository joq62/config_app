-module(deployment).

-export([
	clone/0
	]).

-define(GitDeploymentSpecs,"https://github.com/joq62/deployment_specs.git").
-define(DirDeploymentSpecs,"deployment_specs").

clone()->
    os:cmd("rm -rf "++?DirDeploymentSpecs),
    os:cmd("git clone "++?GitDeploymentSpecs),
    ok.

