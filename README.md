
# storazzo Gem

📦 Storazzo 💎 gem - a Gem to automatically parse your FS for mounts (💽 💾 💿 ) and compute MD5 (🤐) of all files therein and then collect in central DB 🔋 through 📦 StorazzoApp📦 (TM).

![Storazzo logo](assets/storazzo-logo.png)

# INSTALL

`gem install storazzo`

(Latest version is hosted in https://rubygems.org/gems/storazzo)

# Development & Testing

To run the tools locally without installing the gem, use `just` (recommended) or standard Ruby flags.

### Using `just` (Recommended)
This repository includes a `justfile` with common development commands:
* `just setup` - Install dependencies
* `just test` - Run all tests
* `just run scan /path` - Run the local `storazzo` CLI
* `just hello` - Run the local `hello-storazzo` script

### Manual Local Execution
If you don't have `just` installed, you can use `bundle exec` and the `-Ilib` flag:
* **Run CLI**: `bundle exec ruby -Ilib bin/storazzo scan /path`
* **Run Tests**: `bundle exec rake test`
* **Single Test**: `bundle exec ruby -Ilib:test test/media/test_local_folder.rb`

### Why `bundle exec` and `-Ilib`?
Using `bundle exec` ensures all dependencies from the `Gemfile` are available. The `-Ilib` flag adds the local `lib/` directory to the Ruby load path, ensuring your local changes are used instead of any installed gem version.

# Thanks

Inspiration from:

* `hola` gem awesome guide: https://guides.rubygems.org/make-your-own-gem/
* RubyGem from DHH: https://github.com/rails/strong_parameters/tree/master/lib for how to trustucre lib/ and gemspec.
* Stackoverflow and Google for the rest.
* Elio e le Storie Tese: _Sai chi ti scandisce il disco un casino? Storazzo!_
