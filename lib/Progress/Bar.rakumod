use v6.d;

#| The progress bar can be turned on and off.
enum StartStop  «:Stop(False) :Start(True) :Restart(True) :Pause(False)»;
#enum StartStop is export «Stop Start :Pause(0)»;
    my Bool $stop-progress-bar = False;
sub progress-bar (StartStop $start!,
                  :@symbols=[ '#' ],
                  :$spaces = 1,
                  :$sleep-time = 0.25) is export {
    my $num-symbols = @symbols.elems;
    if $start {
        # print a newline unless we've already started
        print "\n" unless $stop-progress-bar == False;
        $stop-progress-bar = False;
        start repeat {
            print @symbols[$++ % $num-symbols], ' ' x $spaces;
            sleep $sleep-time;
        } until $stop-progress-bar;

    }
    else {
        # print a newline unless we've already stopped
        print "\n" unless $stop-progress-bar == True;
        $stop-progress-bar = True;
    }
}

END { progress-bar Stop; }
