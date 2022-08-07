



require "minitest/autorun"
require "storazzo"

class BinaryStorazzoTest < Minitest::Test

    def test_binary_returns_error_with_random_argv 
        ret = `bin/storazzo aaa`
        #puts ret
        #puts "return code is '#{$?.exitstatus}'"
        should_match_string = 'Unknown action1: aaa. Available actions:' # 'ERROR: Unknown action1: aaa. Available actions: ["auto", "help", "show"]'
        assert_equal(
            $?.exitstatus,
            13,
            "Wrong argument should return 13"
        )
        matches_expected_error = ret.match(should_match_string)
        #puts "matches_expected_error: ''#{matches_expected_error}''"
        assert(
            not( matches_expected_error.nil?),
            "Binary should return a string which should contain this string: '#{should_match_string}'"
        )
    end

end