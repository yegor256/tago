# Adds `.ago()` Method to the `Time` Class

[![DevOps By Rultor.com](https://www.rultor.com/b/yegor256/tago)](https://www.rultor.com/p/yegor256/tago)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/tago/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/tago/actions/workflows/rake.yml)
[![PDD status](https://www.0pdd.com/svg?name=yegor256/tago)](https://www.0pdd.com/p?name=yegor256/tago)
[![Gem Version](https://badge.fury.io/rb/tago.svg)](https://badge.fury.io/rb/tago)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/tago.svg)](https://codecov.io/github/yegor256/tago?branch=master)
[![Yard Docs](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/github/yegor256/tago/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/tago)](https://hitsofcode.com/view/github/yegor256/tago)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/tago/blob/master/LICENSE.txt)

First, install it:

```bash
gem install tago
```

Here is how you use it:

```ruby
start = Time.now
# something long
puts "It took #{start.ago} to do it"
```

It's also possible to convert Float seconds to text:

```ruby
s = Time.now - start
puts "It took #{s.seconds}"
```

The `seconds` method accepts optional formatting flags:

```ruby
9.444.seconds           # => "9s444ms"
9.444.seconds(:round)   # => "9s" (omits sub-units)
9.444.seconds(:short)   # => "9s" (also omits sub-units)
300.0.seconds(:pretty)  # => "five minutes" (words instead of abbreviations)
300.0.seconds(:pretty, :short) # => "5 min" (numeric with short unit names)
5.0.seconds(:pretty, :caps)    # => "Five seconds" (capitalizes first letter)
```

The same flags work with `ago`:

```ruby
start.ago(:round)
start.ago(:pretty)
start.ago(:pretty, :short)
start.ago(:pretty, :caps)
start.ago(Time.now, :round)
```

The gem basically extends the `Float` and `Time` classes with new methods.

## How to contribute

Read
[these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute
your pull request. You will need to have
[Ruby](https://www.ruby-lang.org/en/) 3.2+ and
[Bundler](https://bundler.io/) installed. Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
