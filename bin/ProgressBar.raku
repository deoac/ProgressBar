#!/usr/bin/env raku
use v6.d;
use lib 'lib';
use Progress::Bar;

INIT { progress-bar Start ; say "Starting... "}

for ^3 { print "$_ "; sleep 1 }
print "Stopping";
progress-bar Stop;
for ^3 { print "$_ "; sleep 1 }
print "Starting";
progress-bar Start;
for ^3 { print "$_ "; sleep 1 }
print "Pausing";
progress-bar Pause;
for ^3 { print "$_ "; sleep 1 }
print "Re-starting";
progress-bar Restart;
for ^3 { print "$_ "; sleep 1 }
