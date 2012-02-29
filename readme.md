bump
----

Bump replaces tags in an input file with system information, such as
environment variables, program output and time.  All input content is
passed through verbatim, except for the tag replacements.  Bump is
typically used to capture context information in a source file before
a build.

For example, given file foo, below on left, run `bump -o bar.h  foo` to
produce bar.h on right.

    // - Created with <appname> <bumpver>               // - Created with bump 0.9

    #ifndef  <^^outfilebase>_INCLUDED                   #ifndef  BAR_H_INCLUDED
    #define  <^^outfilebase>_INCLUDED                   #define  BAR_H_INCLUDED

    #define  BUILD_CFG  "<buildcfg?=debug>"             #define  BUILD_CFG  "debug"
    #define  <^buildcfg>_BUILD                          #define  DEBUG_BUILD

    #define  DATE     "<%Y-%m-%d>"            ==>       #define  DATE     "2012-02-08"
    #define  TIME     "<%I:%M %p>"                      #define  TIME     "04:53 PM"
    #define  TIME_T   <%s>                              #define  TIME_T   1328741616
    #define  UUID     "<`uuidgen`>"                     #define  UUID     "C0F50E50-5410-...

    #define  USER     "<`whoami`>"                      #define  USER     "john"
    #define  DIR      "<env[PWD]>"                      #define  DIR      "/Users/john/bump"
    #endif                                              #endif


### Usage

    bump [options] [file]

    Options:
        -v, --verbose        Run verbosely
        -h, --help           Emit help information
            --version        Emit version and exit
        -t, --time TIME      Set specific time
        -o, --output FILE    Output file name
        -D, --define DEFINE  Define variable

    Input file name is './version', if no file specified.
    Input file is created with default content, if it does not exist.

    Examples:
        bump -v
        bump -o output.h  -t `date +%s`  foo.ver
        bump --output header.hpp  version
        bump -Dbuildcfg=release -Ddate=02-12-12  foo  >foo.h


### Syntax

Bump replaces tags with values.  Tags are surrounded by `< >` characters
(e.g. `<tag>`).  Bump knows no language syntax, so all tags are replaced
regardless of their location in the input file.  Literal `< >` characters
may be passed through Bump by adding a preceding backslash
(i.e. `\<` or `\>`).

Bump filters out comments that start with `~~` (double-tilde), up to the end
of the line,  e.g. `~~ my comment`.  Comments that begin in column 1 remove
the entire line, including the newline.  Otherwise, only the comment portion
is removed.

Bump makes five types of replacements -

    Type            Description
    ----            -----------

    Environment     Tags with the '`<env[var]>`' format are replaced with the
    Variables       environment variable 'var'.
                    Example:  <env[HOME]> => /Users/john


    Time Format     Bump stores the time the application is started.  That time
                    can be overridden with the command line option '-t'.

                    Time tags specify a format string for the Ruby Time class's
                    strftime() method.  Time tags must begin with '%'.
                    Example:  <%Y-%m-%d> => 2012-02-08

                    Bump adds two additional time tags -

                      %msbuild  Microsoft's Build value, the number of days
                                since 1 Jan 2000.

                      %msrev    Microsoft's Revision value, the number of
                                seconds since midnight, divided by 2.


    Executable      Tags surrounded by backticks are commands to be executed.
    Output          The tag is replaced with the command output.  Any trailing
                    newline is removed from the output.
                    Example:  <`whoami`> => john


    Program         Bump provides tags with program metadata.
    Metadata
                      Tag           Description             Example
                      ---           -----------             -------
                      appname       Bump's app name         bump
                      bumpver       Bump version            0.9
                      os            OS type                 linux

                      infile        Input file name         /foo/infile.ver
                      infilebase    Input file base name    infile.ver
                      infiledir     Input file directory    /foo
                      infileext     Input file extension    ver

                      outfile       Output file name        /foo/outfile.h
                      outfilebase   Output file base name   outfile.h
                      outfiledir    Output file directory   /foo
                      outfileext    Output file extension   h


    Command         Bump allows tags to be defined on the command line, using
    Line            the -D option.  Example: bump -Dname="Elvis Presley"


Bump provides three optional tag modifiers -

    ^   Place before tag to make replacement upper case.
        Example:  if foo = Foo*Bar, <^foo> => FOO*BAR

    ^^  Place before tag to make replacement upper case C identifier.
        Example:  if foo = Foo-Bar.h, <^^foo> => FOO_BAR_H

    ?=  Place between tag and default value for tag.
        Example:  `<buildcfg?=debug>` sets buildcfg to 'debug', if buildcfg is not already defined.


### Test
'test/bump\_test.rb' is a test suite for Bump.  Use the '-h' option to see
usage, including how to run individual tests.

### Other
Written and tested with Ruby 1.8.7 on OS X 10.7.

[![CC](http://i.creativecommons.org/l/by-sa/3.0/88x31.png)](http://creativecommons.org/licenses/by-sa/3.0/)   &nbsp;Licensed under [Creative Commons](http://creativecommons.org/licenses/by-sa/3.0/)
