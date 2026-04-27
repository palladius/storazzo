# frozen_string_literal: true

# copied from https://github.com/rails/strong_parameters/edit/master/lib/strong_parameters/version.rb
# I;'m copying the DHH philosophy here.
module Storazzo
  # DHH_VERSION = "0.2.3._TODOFileRead.1" # TODO file.read ../../VERSION . chomp
  RICC_VERSION = File.read(File.expand_path('../../VERSION', __dir__)).chomp

  def self.version
    RICC_VERSION
  end
end
