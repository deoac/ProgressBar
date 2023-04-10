use v6.d;
#===============================================================================
#         FiLE: ProgressBar.rakumod
#
#  Description: A module to start and stop a progress bar,
#               while a program is compiling and running.
#
#          Notes:
#         Author: <Shimon Bollinger>  (<deoac.shimon@gmail.com>)
#        Version: 1.0
#  Last Modified: Sun 09 Apr 2023 10:03:51 PM EDT
#===============================================================================

unit package ProgressBar;

# The progress bar can be Started and Stopped
# Pause, Resume, Off, and On are just aliases.
enum StartStop   is export(:DEFAULT, :StartStop,   :Bools)   «:Stop(False)  :Start(True) »;
enum OnOff       is export(:DEFAULT, :OnOff,       :Bools)   «:Off(False)   :On(True)    »;
enum ResumePause is export(:DEFAULT, :ResumePause, :Bools)   «:Pause(False) :Resume(True)»;
enum Spinner     is export(:DEFAULT, :Spinner,     :Special) «:Spin(2)»;
enum Counter     is export(:DEFAULT, :Counter,     :Special) «:Count(3)»;
subset Bools of Bool where * ~~ StartStop|OnOff|ResumePause;

sub hide-cursor { print "\e[?25l"; }
sub show-cursor { print "\e[?25h"; }
END { show-cursor }

proto progress-bar (|) is export(:MANDATORY) {*}
# The progress bar is a Counter
multi progress-bar (Counter $type) {
    progress-bar
        Start,
        symbols         => 0..∞,
        carriage-return => True,
} # end of multi progress-bar (PreDefined $type where $type eq Counter)

# The progress bar is a Spinner
multi progress-bar (Spinner $type) {
    progress-bar
        Start,
        symbols         => «| / - \\»,
        carriage-return => True,
} # end of multi progress-bar (PreDefined $type where $type eq Spinner)

# The generic progress bar.
# By default it outputs ' # ' every quarter second until told to stop.
our $progress-bar-is-running is export = False;

multi progress-bar (Bools:D $start,
                    Str:D   :$symbol          = '',
                            :@symbols         = [],
                    Bool:D  :$carriage-return = False,
                    Int:D   :$spaces          = 1,
                    Rat()   :$sleep-time      = 0.25) is export {

    state Thread $t;
    state Str $sym = '#'; # the default symbol
    if $start.so {
        if $progress-bar-is-running  {
            progress-bar Stop;
        } # end of if $progress-bar-is-running

        # The symbol argument can be one character
        # or an array of characters.
        # If there's only one, make it the first
        # (and only) element of the array.
#prompt "sym => $sym; symbol => $symbol; ({$symbol.so}; ({@symbols.so}))";
        $sym = $symbol if $symbol.so;
        @symbols.push($sym) unless @symbols;

        my $num-syms = @symbols.is-lazy ?? ∞ !! @symbols.elems;

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
                                           !! @symbols[$++ % $num-syms];

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
        $t.finish with $t;
        show-cursor if $carriage-return;
    }
} # end of multi progress-bar (StartStop $start,

=begin pod

=head1 NAME

ProgressBar - Start and stop a progress bar
while a program is compiling and  running


=head1 VERSION

This documentation refers to C<ProgressBar> version 1.0.


=head1 USAGE

    use ProgressBar;

    progress-bar Start;
    progress-bar Stop;
    progress-bar Counter;
    progress-bar Spinner;

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

I recommend adding C<END { progress-bar Stop; }>.
 

=head2 Counter

    progress-bar Counter;

The progress bar will simply be the integers increasing every 0.15 seconds.
Use C<progress-bar Stop> to, well, I<stop> the Counter.

=head2 Spinner

    progress-bar Spinner;

The progress bar will loop thru these characters: C<| / - \>
Use C<progress-bar Stop> to, well, I<stop> the Spinner.

=head1 OPTIONS

The function has the following Signature:

    multi progress-bar (Bools:D $start,
                        Str:D   :$symbol          = '',
                                :@symbols         = [],
                        Bool:D  :$carriage-return = False,
                        Int:D   :$spaces          = 1,
                        Rat()   :$sleep-time      = 0.25) is export {

=head2 $start  (Required)

Any one of C<Start>, C<Stop>, C<Resume>, C<Pause>, C<On>, or C<Off>.

=head2 $symbol (Optional)

This will be the symbol that, well, progresses across your screen. It will
default to the hash symbol C<#>.

Once you set the C<$symbol>, it will use that symbol until you change it.
That is, after C<Stop>ping and C<Resume>ing, it won't revert back to C<#>.

=head2 :@symbols (Optional)

If you want more than one symbol in your progress bar (such as C< ♣️ ♦️ ♠️ ❤️  >),
use this array. The bar will loop over the symbols. It will accept a lazy
array such as C<(1..∞)>.

Defaults to an empty array.

=head2 :$carriage-return (Optional)

Do you want to cursor to return to the left end of the line between each
symbol?  This is useful for spinners that stay in one place.

Defaults to C<False>.

=head2 :$spaces (Optional)

How many spaces do you want between your symbols?

Defaults to 1 space.

=head2 :$sleep-time (Optional)

How much time do you want to pass between each printing of your symbols?

Defaults to 0.25 seconds.

=head1 EXPORTed Symbols

=head2 :MANDATORY

=item sub progress-bar {...}

=head2 :DEFAULT

    Start Stop On Off Resume Pause Spinner Counter

=head2 Tags

=item :StartStop - to import only C<Start> and C<Stop>.

=item :OnOff - to import only C<On> and C<Off>.

=item :ResumePause - to import only C<Resume> and C<Pause>.

=item :Spinner - to import only the C<Spinner>.

=item :Counter - to import only the C<Counter>.

=item :Bools - to import C<Start>, C<Stop>, C<On>, C<Off>, C<Resume>, C<Pause>
I<only>. (i.e. doesn't import C<Spinner> or C<Counter>).

=item :Specials - to import I<only> Spinner and Counter. (i.e. doesn't import
an  y of the C<:Bools>).

zi=head1 DIAGNOSTICS

None.


=head1 DEPENDENCIES

=head2 Build

None.

=head2 Testing

        use Test;
        use Test::Output;

The testing takes about 21 seconds.  I recommend using C<--verbose> so you
have some output while waiting.

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

None known.

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



