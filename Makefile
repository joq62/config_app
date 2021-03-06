all:
	rm -rf  *~ */*~ apps/controller_app/src/*.beam test/*.beam erl_cra*;
	rm -rf  catalog host_specs deployment_specs logs *.service_dir;
	rm -rf  *_info_specs;
	rm -rf _build test_ebin ebin;		
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs;
	echo Done
check:
	rebar3 check

eunit:
	rm -rf  *~ */*~ apps/config_app/src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs *.service_dir;
	rm -rf  *_info_specs;
	rm -rf ebin;
	rm -f rebar.lock;
	mkdir  application_info_specs;
	cp ../application_info_specs/*.spec application_info_specs;
	mkdir  host_info_specs;
	cp ../host_info_specs/*.host host_info_specs;
	mkdir deployment_info_specs;
	cp ../deployment_info_specs/*.depl deployment_info_specs;
	mkdir test_ebin;
	mkdir ebin;
	rebar3 compile;
	cp _build/default/lib/*/ebin/* ebin;
	erlc -o test_ebin test/*.erl;
#	erl -pa ebin -pa test_ebin -sname test -run basic_eunit test -setcookie cookie_test -config config/sys
	erl -pa ebin -pa test_ebin -sname test -run basic_eunit start -setcookie  cookie_test
release:
	rm -rf  *~ */*~  test_ebin/* erl_cra*;
	erlc -o test_ebin test/*.erl;
	erl -pa test_ebin -run release start config_app ../catalog/catalog.specs
