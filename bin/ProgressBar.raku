#!/usr/bin/env raku
use v6.d;
use Progress::Bar;

END  { progress-bar Stop; }

progress-bar Start, symbol => 'X';
# Try starting twice...
say "Starting for 3 seconds... ";
progress-bar Start;
for ^3 { print "$_ "; sleep 1 }

progress-bar Stop;
# try stopping twice
progress-bar Stop;
say "Stopping for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

progress-bar Start, symbol => 'π';
say "Starting with symbol => π for 3 seconds";
for ^3 { print "$_ "; sleep 1 }

progress-bar Pause;
say "Pausing for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

progress-bar Resume, spaces => 3;
say "Resuming with spaces => 3 for 3 seconds";
for ^3 { print "$_ "; sleep 1 }

progress-bar Off;
say "Off-ing for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";

progress-bar On, sleep-time => 2;
say "On-ing with sleep-time => 2 for 6 seconds";
for ^6 { print "$_ "; sleep 1 }

progress-bar Stop;
say "Stopping for 3 seconds";
for ^3 { print "$_ "; sleep 1 }
print "\n";


progress-bar Start, symbols => <a b c>;
say "Starting for 3 seconds with letters";
for ^3 { print "$_ "; sleep 1 }
progress-bar Stop;

progress-bar Start, symbol => <א>;
say "Starting for 3 seconds with Hebrew";
for ^3 { print "$_ "; sleep 1 }
progress-bar Stop;


progress-bar Counter;
say "Counter for 3 seconds";
sleep 3;
progress-bar Stop;


progress-bar Spinner;
say "Spinner for 3 seconds";
sleep 3;
progress-bar Stop;
