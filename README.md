
# storazzo Gem

📦 Storazzo 💎 gem - a Gem to automatically parse your FS for mounts (💽 💾 💿 ) and compute MD5 (🤐) of all files therein and then collect in central DB 🔋 through 📦 StorazzoApp📦 (TM).

# INSTALL

`gem install storazzo`

(Latest version is hosted in https://rubygems.org/gems/storazzo)

# Tests

I still struggle to enforce the include of LOCAL unchecked code rather than latest required system gem (cmon Ruby!)
but I found loads of interesting ways to test my code by googling and StoackOverflowing:

* `rake test TEST="test/sum_test.rb"`
* test-gcs-bucket: `ruby -I test test/test_gcs_bucket.rb` (meh - see below)
* test-media-subfolder: `rake test TEST="test/media/*.rb"`

Single test in single file:

* `rake test TEST="test/sum_test.rb" TESTOPTS="--name=test_returns_two"` (sample)
* `rake test TEST="test/media/test_local_folder.rb" TESTOPTS="--name=test_1_first_directory_parsing_actually_works"`
* `ruby -I test test/test_local_folder.rb -n test_first_directory_parsing_actually_works` (note this includes `storazzo` latest gem 
    and doesnt benefit from LATEST code so its NOT good for testing: use RAKE for that).

**Testing binary files** is hard: by default they 'require storazzo' and use the GEM INSTALLed version which is a few versions away, usually.
So while developing you might want to include the lib/ folder, like this:

* Use local gem (super latest) for checking latest code: `ruby -Ilib bin/hello-storazzo`
* This will use the gem installed a few days ago, likely so wont do you any good to test latest code: `bin/hello-storazzo`

Now to toggle verbosity I believe I need to go into Rakefile (bummer)
# Thanks

Inspiration from:

* `hola` gem awesome guide: https://guides.rubygems.org/make-your-own-gem/
* RubyGem from DHH: https://github.com/rails/strong_parameters/tree/master/lib for how to trustucre lib/ and gemspec.
* Stackoverflow and Google for the rest.
* Elio e le Storie Tese: _Sai chi ti scandisce il disco un casino? Storazzo!_
