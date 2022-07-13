#!/bin/bash

# I want to call stuff with LOCAL gem. How do i require local path gem?!?
#https://stackoverflow.com/questions/22331300/require-local-gem-ruby

(
    echo '$LOAD_PATH.unshift("'$(pwd)'/lib/"); nil' # nil is to mute this super verbose output :) 
    echo "require 'storazzo'"
    echo Storazzo::Main.hi :symbols_are_better
) | irb