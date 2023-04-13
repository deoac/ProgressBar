NAME
====

ProgressBar - Start and stop a progress bar while a program is compiling and running

VERSION 
========

This documentation refers to `ProgressBar` version 1.0.1

USAGE
=====

```raku
use ProgressBar;

# To start a progress bar:
progress-bar Start;

# To start a counter as the progress bar:
progress-bar Counter;

# To start a spinner as the progress bar:
progress-bar Spinner;

# To stop any of the above progress bars:
progress-bar Stop;
```

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

```raku
progress-bar Counter;
```

The progress bar will simply be the integers increasing every 0.15 seconds. Use `progress-bar Stop` to, well, stop the Counter.

Spinner
-------

```raku
progress-bar Spinner;
```

The progress bar will loop thru these characters: `| / - \` Use `progress-bar Stop` to, well, stop the Spinner.

OPTIONS
=======

The function has the following Signature:

```raku
multi progress-bar (Bools:D $start,
                    Str:D   :$symbol          = '',
                            :@symbols         = [],
                    Bool:D  :$carriage-return = False,
                    Int:D   :$spaces          = 1,
                    Rat()   :$sleep-time      = 0.25) is export {
```

$start (Required)
-----------------

Any one of `Start`, `Stop`, `Resume`, `Pause`, `On`, `Off`, `Counter`, or `Spinner`.

:$symbol (Optional)
-------------------

This will be the symbol that, well, progresses across your screen. 

Defaults to the hash symbol `#`.

Once you set the `$symbol`, it will use that symbol until you change it. That is, after `Stop`ping and `Resume`ing, it won't revert back to `#`.

:@symbols (Optional)
--------------------

If you want more than one symbol in your progress bar (such as `♣️ ♦️ ♠️ ❤️ `), use the `@symbols` array. The bar will loop over the symbols. It will also accept a lazy array such as `(1..∞)`.

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

DEPENDENCIES
============

Build
-----

None.

Testing
-------

```raku
use Test;
use Test::Output;
```

The testing takes about 21 seconds. I recommend using `--verbose` so you have some output while waiting.

INCOMPATIBILITIES
=================

None known.

BUGS AND LIMITATIONS
====================

Weird testing bug When testing, you may get this error:
-------------------------------------------------------

    Unhandled exception in code scheduled on thread 4
    Type check failed in binding to parameter '$entry'; 
    expected TAP::Entry but got Nil (Nil)

I don't know the cause, but it's irrelevant to whether the tests pass. 

If you get: 

```bash
# From t/basic.rakutest
ok 1 - ProgressBar loads ok

# From xt/*.rakutest
Please wait ~ 21 seconds...
ok 1 - Is the output good?
ok 2 - Took the right amount of time.
```

then the tests passed.

Difference from Term::ProgressBar
---------------------------------

Our module creates an open-ended progress bar. That is, it doesn't know how much time will be required before stopping. So we can't have a `[=====...]54%` display. If you want that functionality, please check out `Term::ProgressBar`.

Our progress bar is especially useful when compiling and loading takes a while.

None known.

AUTHOR
======

Shimon Bollinger (deoac.shimon@gmail.com)

Source can be located at https://github.com/deoac/ProgressBar .

Comments, pull requests, problems, and suggestions are welcome.

LICENCE AND COPYRIGHT
=====================

Copyright 2023, Shimon Bollinger

This module is free software; you can redistribute it and/or modify it under the [perlartistic](http://perldoc.perl.org/perlartistic.html).

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
[?25h