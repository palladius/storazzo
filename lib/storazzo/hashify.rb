# frozen_string_literal: true

# copied from https://dev.to/ayushn21/how-to-generate-yaml-from-ruby-objects-without-type-annotations-4fli
module Storazzo
  module Hashify
    # Classes that include this module can exclude certain
    # instance variable from its hash representation by overriding
    # this method
    def ivars_excluded_from_hash
      ['this_doesnt_exist']
    end

    def to_hash
      hash = {}
      excluded_ivars = ivars_excluded_from_hash

      # Iterate over all the instance variables and store their
      # names and values in a hash
      instance_variables.each do |var|
        next if excluded_ivars.include? var.to_s

        value = instance_variable_get(var)
        value = value.map(&:to_hash) if value.is_a? Array

        hash[var.to_s.delete('@')] = value
      end

      hash
    end

    def obj_to_hash
      h = {}
      puts self
      instance_variables.each do |var|
        # puts var
        h[var.to_s.delete('@')] = instance_variable_get(var) # send(var.to_s.delete('@'))
      end
      h
    end

    def to_yaml
      to_hash.to_yaml
    end

    def obj_to_yaml
      obj_to_hash.to_yaml
    end
  end
end
