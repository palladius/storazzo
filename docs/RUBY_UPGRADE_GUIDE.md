# 🚀 Ruby Upgrade Guide: 2.7.5 → 3.3.9

**Project:** Storazzo  
**Date:** 2026-01-18  
**Current Version:** Ruby 2.7.5 (EOL)  
**Target Version:** Ruby 3.4.5 (Latest Stable)

## ⚠️ Why Upgrade?

- **Security:** Ruby 2.7.5 reached End of Life in March 2023
- **Performance:** Ruby 3.x is ~3x faster than 2.7
- **Features:** Better pattern matching, improved error messages, Ractor support
- **Compatibility:** Modern gems are dropping 2.7 support

## 📋 Pre-Upgrade Checklist

- [x] Review codebase (see `RUBY_CODE_REVIEW.md`)
- [ ] Backup current state (`git commit -am 'Pre-Ruby upgrade snapshot'`)
- [ ] Run existing tests (`rake test`)
- [ ] Document current test results
- [ ] Check gem compatibility

## 🔧 Step-by-Step Upgrade

### Step 1: Install Ruby 3.3.9

```bash
# Check available versions
rbenv install --list | grep 3.4

# Install Ruby 3.4.5
rbenv install 3.4.5

# Set as local version for this project
cd /usr/local/google/home/ricc/git/storazzo
rbenv local 3.4.5

# Verify installation
ruby -v
# Expected: ruby 3.4.5 (2024-xx-xx revision ...) [x86_64-linux]

# Verify rbenv is using correct version
which ruby
# Expected: /home/ricc/.rbenv/versions/3.4.5/bin/ruby
```

### Step 2: Update Gemspec

```bash
# Edit storazzo.gemspec
# Change line 8 from:
#   s.required_ruby_version = '>= 2.7.5'
# To:
#   s.required_ruby_version = '>= 3.4.0'
```

**File:** `storazzo.gemspec`
```ruby
# frozen_string_literal: true
# coding: utf-8

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 3.4.0'  # ← UPDATED
  s.name = 'storazzo'
  s.version     = File.read('VERSION').chomp
  # ... rest of file
end
```

### Step 3: Update Gemfile (Optional Improvements)

```bash
# Edit Gemfile to add version constraints
```

**File:** `Gemfile`
```ruby
# frozen_string_literal: true

source 'https://rubygems.org'

# Development tools
gem 'rake', '~> 13.0'
gem 'rubocop', '~> 1.60'
gem 'ruby-lsp', '~> 0.0.4', group: :development

# Debugging
gem 'pry', '~> 0.14', group: :development

# Testing (recommended additions)
group :test do
  gem 'minitest', '~> 5.0'
  gem 'minitest-reporters', '~> 1.6'
end
```

### Step 4: Update Dependencies

```bash
# Remove old Gemfile.lock
rm Gemfile.lock

# Install fresh dependencies
bundle install

# Check for any warnings
bundle outdated
```

### Step 5: Run Tests

```bash
# Run full test suite
rake test

# If any failures, check output carefully
# Most likely causes:
# - Keyword argument changes
# - Deprecated syntax
```

### Step 6: Fix Any Compatibility Issues

#### Common Ruby 3.x Changes

**1. Keyword Arguments**
```ruby
# Ruby 2.7 (deprecated warning)
def method(opts = {})
  # ...
end
method(key: 'value')  # Warning: will be keyword arg in Ruby 3

# Ruby 3.x (proper way)
def method(**opts)
  # ...
end
method(key: 'value')  # ✅ Works correctly
```

**2. Hash to Keyword Argument Conversion**
```ruby
# Ruby 2.7 (auto-converts)
def method(key:)
  # ...
end
opts = { key: 'value' }
method(opts)  # Works but warns

# Ruby 3.x (explicit)
method(**opts)  # ✅ Explicit splat required
```

**3. Numbered Parameters**
```ruby
# New in Ruby 2.7+, improved in 3.x
[1, 2, 3].map { _1 * 2 }  # => [2, 4, 6]
```

### Step 7: Update VERSION and CHANGELOG

```bash
# Update VERSION file
echo "0.8.0" > VERSION

# Update CHANGELOG
cat >> CHANGELOG << 'EOF'

## [0.8.0] - 2026-01-18

### Changed
- **BREAKING:** Upgraded minimum Ruby version from 2.7.5 to 3.4.0
- Updated all dependencies to latest compatible versions
- Improved performance with Ruby 3.4.5 optimizations

### Fixed
- Fixed keyword argument warnings
- Updated deprecated syntax

EOF
```

### Step 8: Run Final Verification

```bash
# Clean build
make clean  # if Makefile has clean target

# Run tests again
rake test

# Try running executables
ruby -Ilib bin/hello-storazzo
ruby -Ilib bin/storazzo --help

# Build gem
gem build storazzo.gemspec

# Install locally and test
gem install ./storazzo-*.gem
storazzo --version
```

### Step 9: Commit Changes

```bash
# Check what changed
git status
git diff

# Commit the upgrade
git add .ruby-version storazzo.gemspec Gemfile Gemfile.lock VERSION CHANGELOG
git commit -m 'Upgrade Ruby from 2.7.5 to 3.4.5

- Update minimum Ruby version to 3.4.0 in gemspec
- Refresh all dependencies with bundle install
- All tests passing with Ruby 3.4.5
- Bump version to 0.8.0

BREAKING CHANGE: Requires Ruby >= 3.4.0'
```

## 🧪 Testing Checklist

After upgrade, verify:

- [ ] `rake test` passes all tests
- [ ] `ruby -Ilib bin/storazzo` runs without errors
- [ ] `ruby -Ilib bin/hello-storazzo` works
- [ ] `ruby -Ilib bin/ricdisk-magic` works
- [ ] Gem builds successfully (`gem build storazzo.gemspec`)
- [ ] Gem installs locally (`gem install ./storazzo-*.gem`)
- [ ] No deprecation warnings in output
- [ ] RuboCop passes (`rubocop`)

## 🐛 Troubleshooting

### Issue: `rbenv: version '3.3.9' not installed`

```bash
# Update rbenv
cd ~/.rbenv
git pull

# Update ruby-build
cd ~/.rbenv/plugins/ruby-build
git pull

# Try install again
rbenv install 3.4.5
```

### Issue: Gem compatibility errors

```bash
# Check which gems are incompatible
bundle outdated

# Update specific gem
bundle update <gem-name>

# Or update all (carefully!)
bundle update
```

### Issue: Test failures

```bash
# Run individual test to isolate
rake test TEST="test/test_storazzo.rb"

# Run with verbose output
rake test TESTOPTS="-v"

# Check for keyword argument issues
grep -r "def.*opts = {}" lib/
```

### Issue: RuboCop errors

```bash
# Auto-fix safe issues
rubocop -a

# Auto-fix all issues (use with caution)
rubocop -A

# Or update .rubocop.yml to match Ruby 3.4
echo "TargetRubyVersion: 3.4" >> .rubocop.yml
```

## 📊 Expected Performance Improvements

Ruby 3.4.5 vs 2.7.5:
- **General performance:** ~3x faster
- **Memory usage:** ~10-20% reduction
- **Startup time:** ~2x faster
- **YJIT (JIT compiler):** Additional 20-40% speedup for long-running processes

## 🎯 Post-Upgrade Tasks

1. **Update CI/CD** (if applicable)
   ```yaml
   # .github/workflows/test.yml
   - uses: ruby/setup-ruby@v1
     with:
       ruby-version: '3.4.5'
   ```

2. **Update Documentation**
   - README.md (mention Ruby 3.3+ requirement)
   - Installation instructions
   - Development setup guide

3. **Notify Users**
   - Update RubyGems.org description
   - Add migration guide for users
   - Update GitHub releases

## ✅ Success Criteria

Upgrade is complete when:
- ✅ Ruby 3.4.5 installed and active
- ✅ All tests passing
- ✅ No deprecation warnings
- ✅ Gem builds successfully
- ✅ All executables work
- ✅ Changes committed to git
- ✅ VERSION and CHANGELOG updated

## 📚 References

- [Ruby 3.4 Release Notes](https://www.ruby-lang.org/en/news/2024/12/25/ruby-3-4-0-released/)
- [Ruby 2.7 to 3.0 Migration Guide](https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/)
- [Keyword Arguments Changes](https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/)

---

**Ready to upgrade? Let's do this! 🇮🇹 🚀**
