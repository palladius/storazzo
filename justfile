# Justfile for Storazzo

# List all commands
default:
    @just --list

# Install dependencies
setup:
    bundle install

# Run all tests
test:
    bundle exec rake test

# Run a specific test file
test-file file:
    bundle exec ruby -Ilib:test {{file}}

# Run linting
lint:
    bundle exec rubocop

# Build the gem
build:
    gem build storazzo.gemspec

# Run the local version of storazzo
run *args:
    bundle exec ruby -Ilib bin/storazzo {{args}}

# Run hello-storazzo
hello:
    bundle exec ruby -Ilib bin/hello-storazzo

# Build and deploy the gem to RubyGems
deploy: build
    gem push storazzo-$(cat VERSION).gem
