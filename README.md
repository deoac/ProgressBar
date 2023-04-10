NAME
====

ProgressBar - Start and stop a progress bar while a program is compiling and running

VERSION
=======

This documentation refers to `ProgressBar` version 1.0.

USAGE
=====

    use ProgressBar;

    progress-bar Start;
    progress-bar Stop;
    progress-bar Counter;
    progress-bar Spinner;

DESCRIPTION
===========

If compiling takes a long time, or there are significant wait-times while running, it's nice to show a progress bar. The user then knows the program is still working and not hung or in an infinite loop.

Simplest Use
------------

The simplest use is to put `progress-bar Start;` and `progress-bar Stop;` at the appropriate places in your code.

The progress bar will look like this: `# # # # # # # ...`

You can use `On` and `Resume` as synonyms for `Start`; `Off` and `Pause` as synonyms for `Stop`.

I recommend adding `END { progress-bar Stop; }`.

Counter
-------

    progress-bar Counter;

The progress bar will simply be the integers increasing every 0.15 seconds. Use `progress-bar Stop` to, well, stop the Counter.

Spinner
-------

    progress-bar Spinner;

The progress bar will loop thru these characters: `| / - \` Use `progress-bar Stop` to, well, stop the Spinner.

OPTIONS
=======

The function has the following Signature:

    multi progress-bar (Bools:D $start,
                        Str:D   :$symbol          = '',
                                :@symbols         = [],
                        Bool:D  :$carriage-return = False,
                        Int:D   :$spaces          = 1,
                        Rat()   :$sleep-time      = 0.25) is export {

$start (Required)
-----------------

Any one of `Start`, `Stop`, `Resume`, `Pause`, `On`, `Off`, `Counter`, or `Spinner`.

$symbol (Optional)
------------------

This will be the symbol that, well, progresses across your screen. It will default to the hash symbol `#`.

Once you set the `$symbol`, it will use that symbol until you change it. That is, after `Stop`ping and `Resume`ing, it won't revert back to `#`.

:@symbols (Optional)
--------------------

If you want more than one symbol in your progress bar (such as `♣️ ♦️ ♠️ ❤️ `), use this array. The bar will loop over the symbols. It will accept a lazy array such as `(1..∞)`.

Defaults to an empty array.

:$carriage-return (Optional)
----------------------------

Do you want to cursor to return to the left end of the line between each symbol? This is useful for spinners that stay in one place.

Defaults to `False`.

:$spaces (Optional)
-------------------

How many spaces do you want between your symbols?

Defaults to 1 space.

:$sleep-time (Optional)
-----------------------

How much time do you want to pass between each printing of your symbols?

Defaults to 0.25 seconds.

EXPORTed Symbols
================

:MANDATORY
----------

  * sub progress-bar {...}

:DEFAULT
--------

    Start Stop On Off Resume Pause Spinner Counter

Tags
----

  * :StartStop - to import only `Start` and `Stop`.

  * :OnOff - to import only `On` and `Off`.

  * :ResumePause - to import only `Resume` and `Pause`.

  * :Spinner - to import only the `Spinner`.

  * :Counter - to import only the `Counter`.

  * :Bools - to import `Start`, `Stop`, `On`, `Off`, `Resume`, `Pause` *only*. (i.e. doesn't import `Spinner` or `Counter`).

  * :Specials - to import *only* Spinner and Counter. (i.e. doesn't import any of the `:Bools`).

DIAGNOSTICS
===========

None.

DEPENDENCIES
============

Build
-----

None.

Testing
-------

    use Test;
    use Test::Output;

The testing takes about 21 seconds. I recommend using `--verbose` so you have some output while waiting.

INCOMPATIBILITIES
=================

None known.

BUGS AND LIMITATIONS
====================

None known.

AUTHOR
======

Shimon Bollinger (deoac.shimon@gmail.com)

Comments, pull requests, problems, and suggestions are welcome.

LICENCE AND COPYRIGHT
=====================

This module is free software; you can redistribute it and/or modify it under the [perlartistic](http://perldoc.perl.org/perlartistic.html).

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
