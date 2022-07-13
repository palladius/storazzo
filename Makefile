
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
	echo "Storazzo::Main.all_tests " | irb -Ilib -rstorazzo
	#echo "Storazzo::Main.all_mounts " | irb -Ilib -rstorazzo
	#echo 2. Testing ricdisk-magic
	#bin/ricdisk-magic Ciao-da-Makefile
	echo 3. run rake test.. ont configured yet just a memo for the future.
	RUBYOPT="-W0" rake test
	@echo 'OK: ALL TESTS PASSED. #STIKA'

irb:
	irb -Ilib -rstorazzo

watch-test:
	watch -c make test