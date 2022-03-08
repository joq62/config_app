all:
	rm -rf  *~ */*~  src/*.beam test/*.beam erl_cra*;
	rm -rf  catalog host_specs deployment_specs;
	rm -rf _build;
	rm -rf ebin;
	mkdir ebin;
	rebar3 compile;
	rm -rf  _build ebin catalog host_specs deployment_specs test_ebin;	
	echo Done
eunit:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin/* erl_cra*;
	rm -rf _build;
	rm -rf ebin;
	mkdir ebin;
	rebar3 compile;
	cp -r _build/default/lib/*/ebin/* ebin;
	erlc -o test_ebin test/*.erl;
	erl -pa test_ebin -pa ebin -sname test -run basic_eunit test
release:
	rm -rf  *~ */*~  test_ebin/* erl_cra*;
	erlc -o test_ebin test/*.erl;
	erl -pa test_ebin -run release start config_app ../catalog/catalog.specs
