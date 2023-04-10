#!/usr/bin/env raku
use v6.d;
use ProgressBar;

END  { progress-bar Off; }

say "Try stopping before ever starting...";
progress-bar Stop;
say "Stopping for 3 seconds...";
for ^3 { print "$_ "; sleep 1 }
print "\n" x 2;

say "Try starting twice (first with 'X')...";
progress-bar Start, symbol => 'X';
print "Starting again for 3 seconds (now with '#')... ";
progress-bar Start, symbol => '#';
for ^3 { print "$_ "; sleep 1 }
print "\n" x 2;

print "Try stopping twice";
progress-bar Stop;
say "Stopping for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

progress-bar Stop;
say "Stopping again for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n" x 2;

progress-bar Start, symbol => 'π';
print "Starting with symbol => π for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

progress-bar Pause;
say "Pausing for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n" x 2;

progress-bar Resume, spaces => 3;
print "Resuming with spaces => 3 for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

progress-bar Off;
say "Off-ing for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n" x 2;

progress-bar On, sleep-time => 2;
print "On-ing with sleep-time => 2 for 6 seconds";
for ^6 { print "$_ "; sleep 1 }

progress-bar Stop;
say "Stopping for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n" x 2;


progress-bar Start, symbols => <a b c>;
print "Starting for 3 seconds with letters";
for ^3 { print "$_ "; sleep 1 }
progress-bar Stop;
print "\n" x 2;

progress-bar Start, symbol => <א>;
print "Starting for 3 seconds with Hebrew";
for ^3 { print "$_ "; sleep 1 }
progress-bar Stop;
print "\n" x 1;

progress-bar Start, symbols => (1..∞);
print "Starting for 6 seconds with a lazy, infinite List";
for ^6 { sleep 1 }
progress-bar Stop;
print "\n" x 1;

progress-bar Counter;
print "Counter for 3 seconds";
sleep 3;
progress-bar Off;
print "\n" x 1;


progress-bar Spinner;
print "Spinner for 3 seconds";
sleep 3;
progress-bar Off;
print "\n" x 1;

say "Done!";
