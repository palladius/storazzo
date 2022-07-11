
VER = $(shell cat VERSION)

.PHONY: test clean


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
	echo 1. Testing the library end to end by requiring it..
	echo "Storazzo.all_tests " | irb -Ilib -rstorazzo
	echo 2. Testing ricdisk-magic.rb
	bin/ricdisk-magic.rb
	@echo 'OK: ALL TESTS PASSED. #STIKA'

watch-test:
	watch -c make test