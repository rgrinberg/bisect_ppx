.PHONY : build
build :
	jbuilder build

.PHONY : test
test : build
	jbuilder runtest

.PHONY : clean
clean :
	jbuilder clean
	make -C tests/usage/ clean

INSTALLED_ENVIRONMENT := \
    OCAMLPATH=`pwd`/_build/install/default/lib \
    PATH=`pwd`/_build/install/default/bin:$$PATH

.PHONY : usage
usage : build
	$(INSTALLED_ENVIRONMENT) make -C tests/usage/

.PHONY : performance
performance : build
	jbuilder build tests/performance/test_performance.exe
	cd _build/default/tests/ && \
	    performance/test_performance.exe -runner sequential
