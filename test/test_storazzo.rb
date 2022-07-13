require "minitest/autorun"
require "storazzo"

class StorazzoTest < Minitest::Test
    def test_storazzo_hi_with_argument
        assert_match "Hello from Storazzo", Storazzo::Main.hi("ruby this should fail")
        assert_match "ruby this should fail", Storazzo::Main.hi("ruby this should fail")
    end
    def test_storazzo_hi_without_argument
        assert_match "Hello from Storazzo", Storazzo::Main.hi()
    end

    def test_storazzo_version_should_have_3_numbers_and_2_dots
#        puts Storazzo::version
        assert_equal Storazzo::version.split('.').size , 3, "should be 3 parts, like A.B.C"
        #major, minor, minuscule = Storazzo::VERSION.split('.')
#        assert_match Storazzo::VERSION, "....."
    end

#   def test_english_hello
#     assert_equal "hello world",
#       Hola.hi("english")
#   end

#   def test_any_hello
#     assert_equal "hello world",
#       Hola.hi("ruby")
#   end

#   def test_spanish_hello
#     assert_equal "hola mundo",
#       Hola.hi("spanish")
#   end
end