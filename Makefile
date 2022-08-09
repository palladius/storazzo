
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
push-to-rubygems-without-tests: build-local 
	gem push ./storazzo-$(VER).gem

list:
	gem list -r storazzo

test-all:
	echo 1. Testing the library end to end by requiring it..
	echo "Storazzo::Main.all_tests "  | irb -Ilib -rstorazzo
	make mounts
	#echo 2. Testing ricdisk-magic
	#bin/ricdisk-magic Ciao-da-Makefile
	echo 3. run rake test.. ont configured yet just a memo for the future.
	RUBYOPT="-W0" rake test
	echo 4. Prove I can include local gem in irb and play around. Similarly to rails console without reload.  
	make irb-test
	@echo 'OK: ALL TESTS PASSED. #STIKA'

test:
	RUBYOPT="-W0" rake test

# RicDisk test
mounts:
	echo "Storazzo::Main.all_mounts ; nil" | irb -Ilib -rstorazzo

irb:
	irb -Ilib -rstorazzo
irb-test:
	./irb-test.sh

watch-test:
	watch -c make test

test-gcs-bucket:
	#echo "Warning this uses the INCLUDED gem not the latest one in development'
	#ruby -I test test/media/test_gcs_bucket.rb
	rake test TEST=test/media/test_gcs_bucket.rb

test-local-folder:
	echo "Warning this uses the INCLUDED gem not the latest one in development'
	ruby -I test test/media/test_local_folder.rb
# https://medium.com/@tegon/quick-guide-to-minitest-arguments-745bf9fe4b3
test-media-subfolder:
	rake test TEST="test/media/*.rb"
test-verbose:
	rake test:verbose --verbose 
test-silent:
	RUBYOPT="-W0" rake test:silent --verbose 
test-single-file-continuously:
	\watch -n 5 --color rake test TEST="test/media/test_local_folder.rb"

test-binary-with-local-gem:
	ruby -Ilib bin/hello-storazzo
test-binary-with-system-gem:
	bin/hello-storazzo
	