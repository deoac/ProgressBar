use v6.d;
#===============================================================================
#         FiLE: Bar.rakumod
#
#  Description: A module to start and stop a progress bar,
#               while a program is compiling and running.
#
#          Notes:
#         Author: <Shimon Bollinger>  (<deoac.bollinger@gmail.com>)
#        Version: 0.1
#  Last Modified: Wed 15 Mar 2023 07:28:22 PM EDT
#===============================================================================

unit package Progress::Bar;

#| The progress bar can be turned on and off.
#| Pause, Restart, Off, and On are just aliases.
enum StartStop is export «
                          :Stop(False)  :Start(True)
                          :Pause(False) :Restart(True)
                          :Off(False)   :On(True)
                         »;

# We've provided two special progress "bar"s.
enum PreDefined is export «Spinner Counter»;

use Terminal::ANSI; # only needed for showing/hiding the cursor.

# The progress bar is a Counter
multi progress-bar (PreDefined $type where $type == Counter) {
    progress-bar
        Start,
        symbols         => 0..∞,
        carriage-return => True,
        sleep-time      => 0.12,
} # end of multi progress-bar (PreDefined $type where $type == Counter)

# The progress bar is a Spinner
multi progress-bar (PreDefined $type where $type == Spinner) {
    progress-bar
        Start,
        symbols         => «| / - \\»,
        carriage-return => True,
        sleep-time      => 0.15,
} # end of multi progress-bar (PreDefined $type where $type == Spinner)

# The generic progress bar.
# By default it outputs ' # ' every quarter second until told to stop.
my Bool $stop-progress-bar = False;
multi progress-bar (StartStop:D  $start,
                    Str         :$symbol          = '#',
                                :@symbols,
                    Bool:D      :$carriage-return = False,
                    Int:D       :$spaces          = 1,
                    Rat:D       :$sleep-time      = 0.25) is export {
    # If we'll be printing a <CR> after every symbol,
    # we don't want to see the cursor
    hide-cursor if $carriage-return;

    # The symbol argument can be one character or an array of characters.
    # If there's only one, make it the first (and only) element of the array.
    @symbols.push($symbol) unless @symbols;
    my $num-symbols = @symbols.elems;
    if $start {
        # print a newline unless we've already started
        print "\n" unless $stop-progress-bar == False;
        $stop-progress-bar = False;
        start repeat {
            # If @symbols is a lazy list, don't loop through the inifinite list.
            # If it's not lazy, then loop through the finite list.
            print @symbols.is-lazy ?? @symbols[$++]
                                   !! @symbols[$++ % $num-symbols];

            # The symbol will be followed be either a <CR>
            # or a set number of spaces.
            print $carriage-return ?? "\r"
                                   !! ' ' x $spaces;

            sleep $sleep-time;
        } until $stop-progress-bar;
    }
    else { # Stop (or Pause) the progress bar.
        # print a newline unless we've already stopped
        print "\n" unless $stop-progress-bar == True;
        $stop-progress-bar = True;
    }
    show-cursor if $carriage-return;
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

This documentation refers to C<Progress::Bar> version 0.1


=head1 USAGE

    use Progress::Bar;

    progress-bar Start;
    progress-bar Stop;
    progress-bar Restart;  # An alias for Start
    progress-bar Pause;    # An alias for Stop

=head1 REQUIRED ARGUMENTS

A complete list of every argument that must appear on the command line.
when the application  is invoked, explaining what each of them does, any
restrictions on where each one may appear (i.e. flags that must appear
before or after filenames), and how the various arguments and options
may interact (e.g. mutual exclusions, required combinations, etc.)

If all of the application's arguments are optional this section
may be omitted entirely.


=head1 OPTIONS

A complete list of every available option with which the application
can be invoked, explaining what each does, and listing any restrictions,
or interactions.

If the application has no options this section may be omitted entirely.


=head1 DESCRIPTION

A full description of the application and its features.
May include numerous subsections (i.e. =head2, =head3, etc.)


=head1 DIAGNOSTICS

A list of every error and warning message that the application can generate
(even the ones that will "never happen"), with a full explanation of each
problem, one or more likely causes, and any suggested remedies. If the
application generates exit status codes (e.g. under Unix) then list the exit
status associated with each error.


=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the application,
including the names and locations of any configuration files, and the
meaning of any environment variables or properties that can be set. These
descriptions must also include details of any configuration language used
(also see  QUOTE \" " INCLUDETEXT "19_Miscellanea" "XREF40334_Configuration_Files_"\! Configuration Files QUOTE \" " QUOTE " in Chapter "  in Chapter  INCLUDETEXT "19_Miscellanea" "XREF55683__"\! 19).


=head1 DEPENDENCIES

A list of all the other modules that this module relies upon, including any
restrictions on versions, and an indication whether these required modules are
part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.


=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for
system or program resources, or due to internal limitations of Perl
(for example, many modules that use source code filters are mutually
incompatible).


=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication
whether they are likely to be fixed in an upcoming release.

Also a list of restrictions on the features the module does provide:
data types that cannot be handled, performance issues and the circumstances
in which they may arise, practical limitations on the size of data sets,
special cases that are not (yet) handled, etc.

The initial template usually just has:

There are no known bugs in this module.
Please report problems to <Shimon Bollinger>  (<deoac.shimon@gmail.com>)
Patches are welcome.

=head1 AUTHOR

<Shimon Bollinger>  (<deoac.shimon@gmail.com>)


=head1 LICENCE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic|http://perldoc.perl.org/perlartistic.html>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=end pod



