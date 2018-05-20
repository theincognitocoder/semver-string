# Semver String

[![Build Status](https://travis-ci.org/theincognitocoder/semver-string.svg?branch=master)](https://travis-ci.org/theincognitocoder/semver-string) [![Coverage Status](https://coveralls.io/repos/theincognitocoder/semver-string/badge.svg?branch=master)](https://coveralls.io/r/theincognitocoder/semver-string?branch=master)

Semver String

## Links of Interest

* [Documentation](https://www.rubydoc.info/github/theincognitocoder/semver-string/master)
* [Changelog](https://github.com/theincognitocoder/semver-string/blob/master/CHANGELOG.md)
* [Gitter Channel](https://gitter.im/theincognitocoder/semver-string)

## Installation

Add semver-string to your project's Gemfile and then bundle install.

```ruby
gem 'semver-string', '~> 1'
```

## Basic Usage

Begin by requiring the gem:

```ruby
require 'semver/string'
```

You can construct a `Semver::String` from a Ruby String:

```ruby
version = Semver::String.parse('1.2.3-rc.1+build-123456789')

version.major #=> 1
version.minor #=> 2
version.patch #=> 3
version.pre_release #=> "rc.1"
version.build_metadata #=> "build-123456789"
```

You can also construct one from the semver components:

```ruby
# only major, minor, and patch are required
version = Semver::String.new(
  major: 1,
  minor: 2,
  patch: 3,
  pre_release: 'rc.1',
  build_metadata: 'build-123456789')

version.to_s #=> "1.2.3-rc.1+build-123456789"
```

`Semver::String` objects can be compared and sorted. Sorting is done
according to the rules defined at [semver.org](https://semver.org/).

```
Semver::String.parse('1.10.0') < Semver::String.parse('1.2.0') #=> false
```

## License

Copyright 2018 The Incognito Coder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
