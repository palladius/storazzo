# TODO
require "minitest/autorun"
require "storazzo"


#require 'pry' # must install the gem... but you ALWAYS want pry installed anyways


class AbstractRicDiskTest < Minitest::Test

    include Storazzo::Common

    def test_super_duper_list_all_with_type_returns_something
        deb "This would be already... something :) it means they're all implemented"
        ret =
        assert(
            ret.class,
            Array,
            "test_super_duper_list_all_with_type_returns_something should return an array.."
        ) 
    end

end