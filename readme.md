#bump
- - - - - - - -

bump replaces text tags in a file with information, such as environment
variables, program output and time.  It's typical use is to add timestamp and
version information to a C header file before each build.  See 'Example' below.


## Usage

	bump [options] [file]

	Options:
	    -v, --verbose        Run verbosely
	    -h, --help           Emit help information
	        --version        Emit version and exit
	    -t, --time TIME      Set specific time
	    -o, --output FILE    Output file name
	    -D, --define DEFINE  Define variable

	File is the input file.  The default name is 'version', if not specified.

	Examples:
	    bump -v
	    bump -o output.h  -t `date +%s`  foo.ver
	    bump --output header.hpp  version
	    bump -Dbuildcfg=release -Ddate=02-12-12  foo  >foo.h


## Example

If 'version' file is this, running './bump -o foo.h' produces foo.h.
                      |                                        |
                      v                                        v
	// - Created with <appname> <bumpver>           // - Created with bump 0.9

	#ifndef  <^^outfilebase>_INCLUDED               #ifndef  FOO_H_INCLUDED
	#define  <^^outfilebase>_INCLUDED               #define  FOO_H_INCLUDED

	#define  BUILD_CFG  "<buildcfg?=debug>"         #define  BUILD_CFG  "debug"
	#define  <^buildcfg>_BUILD                      #define  DEBUG_BUILD

	#define  DATE     "<%Y-%m-%d>"                  #define  DATE     "2012-02-08"
	#define  TIME     "<%I:%M %p>"                  #define  TIME     "04:53 PM"
	#define  TIME_T   <%s>                          #define  TIME_T   1328741616

	#define  USER     "<`whoami`>"                  #define  USER     "john"
	#define  DIR      "<env[PWD]>"                  #define  DIR      "/Users/elvis/bump"
	#endif                                          #endif


## Syntax

Replacement tags are surrounded by '<\>' characters, i.e. '<foo>'.  All tags
get replaced, regardless of location in the input file.   Tags at any location will get replaced.
	The
language of the input file is opaque to bump.  Tags at any location will get replaced.  To place a literal '<' or '>' in a
file, place a backslash before the character ('\<' or '\\>').

There are four types of replacements -

###Environment Variables
Tags with the '<env[var]>' format are replaced with the environment variable
'var'.

###Time Format
bump stores the time the application is started.  The time can also be
specified on the command line using the '-t' option.  Tags with a time format,
are replaced with the output of [strftime](http://ruby-doc.org/core-1.8.7/Time.html#method-i-strftime)()
when passed that format.  Time tags must begin with '%'.

###Executable Output
Tags with commands in backticks, i.e. <`whoami`>, will be replaced with the
output of the command.  Any trailing newline is removed from the output.

###Program Metadata

	appname        bump
	bumpver        0.9
	buildcfg       debug
	os             linux
	msbuild        32378
	msrev          21432

	infile         /foo/infile.ver
	infilebase     infile.ver
	infiledir      /foo/
	infileext      ver

	outfile        /foo/outfile.h
	outfilebase    outfile.h
	outfiledir     /foo/
	outfileext     h



###Comments
  bump comments start with '##' and end at the end of the current line.  They
  are removed from the output.
  Comments , .  Lines that
  start with a comment delimiter are completely removed.  Other comments remove
  only the comment portion of the line.

  C comments (// and /*..*/) have no special meaning in bump.  A single '#'
  does not start a comment.


There are two modifiers that can be prefixed to tags.
'^'  - replacement is upper case
'^^' - replacement is upper case C identifier (foo+bAr => FOO_BAR)  (upper case, replace invalid with _)

A default value can also be specified with the '?=' delimiter.  <buildcfg?=debug>

Greater-than and less-than may be placed in output by prefixing with a backslash. ('\<' => '<'


## Test
test/bump\_test.rb is a test suite for bump.  Type 'test/bump\_test.rb' to run
the entire suite.  Type 'test/bump\_test.rb -h' to see usage, including how to
run individual tests.

## Other
Written and tested with Ruby 1.8.7 on OS X 10.7.

[![CC](http://i.creativecommons.org/l/by-sa/3.0/88x31.png)](http://creativecommons.org/licenses/by-sa/3.0/)   &nbsp;Licensed under [Creative Commons](http://creativecommons.org/licenses/by-sa/3.0/)
