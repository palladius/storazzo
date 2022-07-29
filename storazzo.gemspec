Gem::Specification.new do |s|
    s.name        = "storazzo"
    # TOSDO: copy approach from here to dry version calculating: https://github.com/rails/strong_parameters/blob/master/strong_parameters.gemspec#L15
    s.version     = File.read("VERSION").chomp # TODO cat version File.read(@,.VERSION).chomp
    s.summary     = "storazzo is an amazing gem. Code is in https://github.com/palladius/storazzo"
    s.description = "A simple gem to manage your external hard drives and extract MD5 and common stuff from them."
    s.authors     = ["Riccardo Carlesso"]
    s.email       = "name dot surname at popular Google-owned Mail"
    # Autoglob as per https://stackoverflow.com/questions/11873294/determining-the-gems-list-of-files-for-the-specification
    s.files = %w(Gemfile LICENSE README.md Makefile Rakefile storazzo.gemspec VERSION) +  Dir["{bin,lib,test,var}/**/*"] 
    s.test_files = Dir["test/**/*"] + Dir["var/test/**/*"] 
    s.executables = [
        "ricdisk-magic",
        "stats-with-md5",
    ]
    s.homepage    = "https://rubygems.org/gems/storazzo" # maybe https://github.com/palladius/storazzo
    s.license       = "MIT"
    #s.add_dependency "activesupport", "~> 3.0"
    s.add_dependency "pry" # , "~> 3.0"
  end