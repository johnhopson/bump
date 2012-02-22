#!/usr/bin/env ruby
# ------------------  (c)2011 john hopson  -------------------
#
#  Test suite for bump application.
#
#  - Get usage with 'bump_test.rb -h'
#
#  - Requires GCC, but only basic features.
#
#  - Written and tested with ruby 1.8.7 on OS X.
#
#  - Hosted at github.com/johnhopson/bump
#
#  - 'license' file has release terms
#

$: << File.join(File.dirname(__FILE__), '..')

require 'stringio'
require 'test/unit'


class TestBump < Test::Unit::TestCase

  def setup
  end

  def  test_help

    expectedhelp = <<-end.gsub(/^ {6}/, '')
      Version and build information tool.

      Usage: bump [options] [file]

      Options:
          -v, --verbose                    Run verbosely
          -h, --help                       Emit help information
              --version                    Emit version and exit
          -t, --time TIME                  Set specific time
          -o, --output FILE                Output file name
          -D, --define DEFINE              Define variable

      Input file name is './version', if no file specified.
      Input file is created with default content, if it does not exist.

      Examples:
          bump -v
          bump -o output.h  -t `date +%s`  foo.ver
          bump --output header.hpp  version
          bump -Dbuildcfg=release -Ddate=02-12-12  foo  >foo.h

      See readme.md for input file syntax.

      end

    assert_equal  expectedhelp, `./bump  --help`
  end

end
