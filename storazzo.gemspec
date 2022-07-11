Gem::Specification.new do |s|
    s.name        = "storazzo"
    s.version     = File.read("VERSION").chomp # TODO cat version File.read(@,.VERSION).chomp
    s.summary     = "storazzo is an amazing gem. Code is in https://github.com/palladius/storazzo"
    s.description = "A simple gem to manage your external hard drives and extract MD5 and common stuff from them."
    s.authors     = ["Riccardo Carlesso"]
    s.email       = "name dot surname at popular Google-owned Mail"
    s.files       = [
        "bin/ricdisk-magic.rb",
        "lib/storazzo.rb",
#        "lib/storazzo/*.rb",
        "lib/storazzo/colors.rb",
        "lib/storazzo/translator.rb",
    ]
    s.homepage    = "https://rubygems.org/gems/storazzo" # maybe https://github.com/palladius/storazzo
    s.license       = "MIT"
  end