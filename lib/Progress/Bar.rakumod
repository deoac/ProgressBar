use v6.d;
#===============================================================================
#         FiLE: Bar.rakumod
#
#  Description: A module to start and stop a progress bar,
#               while a program is compiling and running.
#
#          Notes:
#         Author: <Shimon Bollinger>  (<deoac.shimon@gmail.com>)
#        Version: 1.0
#  Last Modified: Sat 08 Apr 2023 06:49:57 PM EDT
#===============================================================================

unit package Progress::Bar;


# The progress bar can be turned on and off.
# Pause, Resume, Off, and On are just aliases.
enum StartStop is export «
                          :Stop(False)  :Start(True)
                          :Pause(False) :Resume(True)
                          :Spinner(2)   :Counter(3)
                         »;

sub hide-cursor { print "\e[?25l"; }
sub show-cursor { print "\e[?25h"; }
END { show-cursor }

# The progress bar is a Counter
multi progress-bar (StartStop $type where $type eq Counter) {
    progress-bar
        Start,
        symbols         => 0..∞,
        carriage-return => True,
} # end of multi progress-bar (PreDefined $type where $type eq Counter)

# The progress bar is a Spinner
multi progress-bar (StartStop $type where $type eq Spinner) {
    progress-bar
        Start,
        symbols         => «| / - \\»,
        carriage-return => True,
} # end of multi progress-bar (PreDefined $type where $type eq Spinner)

#TODO Add progress-bar that toggles
##TODO Make the symbol a static, so Resume uses the same character
#
# The generic progress bar.
# By default it outputs ' # ' every quarter second until told to stop.
our $progress-bar-is-running is export = False;

multi progress-bar (StartStop:D  $start,
                    Str:D       :$symbol          = '#',
                                :@symbols         = [],
                    Bool:D      :$carriage-return = False,
                    Int:D       :$spaces          = 1,
                    Rat()       :$sleep-time      = 0.25) is export {

    state Thread $t;
    if $start.so {
        if $progress-bar-is-running  {
            progress-bar Stop;
        } # end of if $progress-bar-is-running

        # The symbol argument can be one character
        # or an array of characters.
        # If there's only one, make it the first
        # (and only) element of the array.
        @symbols.push($symbol) unless @symbols;

        my $num-symbols = @symbols.is-lazy ?? ∞ !! @symbols.elems;

        # If we'll be printing a <CR> after every symbol,
        # we don't want to see the cursor
        hide-cursor if $carriage-return;

        $t = Thread.start(
            { # The 'code' argument
                repeat {
                    print "\n" unless $progress-bar-is-running;
                    $progress-bar-is-running = True;

                    # If @symbols is a lazy list,
                    # don't loop through the inifinite list.
                    # If it's not lazy, then loop through the finite list.
                    print @symbols.is-lazy ?? @symbols[$++]
                                        !! @symbols[$++ % $num-symbols];

                    # The symbol will be followed by either a <CR>
                    # or a set number of spaces.
                    print $carriage-return ?? "\r"
                                        !! ' ' x $spaces;

                    sleep $sleep-time;
                } while $progress-bar-is-running;
            }, # end of the 'code' argument
            :app_lifetime
        ) # end of $t = Thread.start
    }
    else { # We're stopping the progress bar
        # print a newline unless we've already stopped
        print "\n" if $progress-bar-is-running;
        $progress-bar-is-running = False;
        $t.finish;
        show-cursor if $carriage-return;
    }
} # end of multi progress-bar (StartStop $start,

##############################################################################
##    Example 7.1 (Recommended) from Chapter 7 of "Perl Best Practices"     ##
##     Copyright (c) O'Reilly & Associates, 2005. All Rights Reserved.      ##
##############################################################################

=begin pod

=head1 NAME

Progress::Bar - Start and stop a progress bar
while a program is compiling and  running


=head1 VERSION

This documentation refers to C<Progress::Bar> version 1.0.


=head1 USAGE

    use Progress::Bar;

    progress-bar Start;
    progress-bar Counter;
    progress-bar Spinner;
    progress-bar Stop;

=head1 DESCRIPTION

If compiling takes a long time, or there are significant wait-times while
running, it's nice to show a progress bar.  The user then knows the
program is still working and not hung or in an infinite loop.

=head2 Simplest Use

The simplest use is to put C<progress-bar Start;> and C<progress-bar Stop;> at
the appropriate places in your code.

The progress bar will look like this: C<# # # # # # # ...>

You can use C<On> and C<Resume> as synonyms for C<Start>;
C<Off> and C<Pause> as synonyms for C<Stop>.

=head2 Counter

    progress-bar Counter;

The progress bar will simply be the integers increasing every 0.15 seconds.
Use C<progress-bar Stop> to, well, I<stop> the Counter.

=head2 Spinner

    progress-bar Spinner;

The progress bar will loop thru these characters: C<| / - \>
Use C<Stop> to, well, I<stop> the Spinner.

=head1 OPTIONS

The function has the following Signature:

    enum StartStop is export «
                            :Stop(False)  :Start(True)
                            :Pause(False) :Resume(True)
                            :Off(False)   :On(True)
                            »;
    multi progress-bar (StartStop:D  $start,
                        Str         :$symbol,
                                    :@symbols         = [ '#' ],
                        Bool:D      :$carriage-return = False,
                        Int:D       :$spaces          = 1,
                        Rat:D       :$sleep-time      = 0.25)

=head2 $start  (Required)

Any one of C<Start>, C<Stop>, C<Resume>, C<Pause>, C<On>, or C<Off>.

=head2 $symbol (Optional)

Defaults to the empty string.

=head2 :@symbols (Optional)

Defaults to an array of one element, C<#>.

=head2 :$carriage-return (Optional)

Defaults to C<False>.

=head2 :$spaces (Optional)

Defaults to 1 space.

=head2 :$sleep-time (Optional)

Defaults to 0.25 seconds.

=head1 DIAGNOSTICS

None.


=head1 DEPENDENCIES

    use Terminal::ANSI

=head1 TESTING

You will need

        use Test;
        use Trap;

to run the tests.

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

=head1 AUTHOR

Shimon Bollinger  (deoac.shimon@gmail.com)

Comments, pull requests, problems, and suggestions are welcome.

=head1 LICENCE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the L<perlartistic|http://perldoc.perl.org/perlartistic.html>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=end pod



