#!/usr/bin/env raku
use v6.d;
use Progress::Bar;

BEGIN { say "Starting for 3 seconds... "; progress-bar Start; }
END  { progress-bar Stop; }

=begin comment
for ^3 { print "$_ "; sleep 1 }

progress-bar Stop;
say "Stopping for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

print "Starting with symbol => π for 3 seconds";
progress-bar Start, symbol => 'π';
for ^3 { print "$_ "; sleep 1 }

progress-bar Pause;
say "Pausing for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

print "Resuming with spaces => 3 for 3 seconds";
progress-bar Resume, spaces => 3;
for ^3 { print "$_ "; sleep 1 }

progress-bar Off;
say "Off-ing for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

print "On-ing with sleep-time => 2 for 6 seconds";
progress-bar On, sleep-time => 2;
for ^6 { print "$_ "; sleep 1 }
=end comment

progress-bar Stop;


say "Counter for 3 seconds";

    progress-bar
        Start,
        symbols         => 0..∞,
        carriage-return => True,;

sleep 3;
progress-bar Stop;



say "Spinner for 3 seconds";
progress-bar Spinner;
sleep 3;
progress-bar Stop;
