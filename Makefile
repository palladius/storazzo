
VER = $(shell cat VERSION)

help:
	cat Makefile

build-local:
	gem build storazzo.gemspec

build: build-local 

install:
	gem install ./storazzo-$(VER).gem

push-to-rubygems: build-local test
	gem push ./storazzo-$(VER).gem

list:
	gem list -r storazzo

test:
	echo Testing the library end to end by requiring it..
	echo "Storazzo.all_tests " | irb -Ilib -rstorazzo
	@echo 'OK: ALL TESTS PASSED. #STIKA'

watch-test:
	watch -c make test