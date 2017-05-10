Hi there,

So I'm fairly confident in my Compiler.c program, and InstrUtils.c is pretty trivial, but I wanted to let you know that for Optimizer.c, I was unable to finish dealing with the edge case where the value at the register + offset was overwritten. Thus, my current code has it assume that these values are 'crucial', when in fact they are not (ran out of time).

A quicker means of explaining would be thus:

Take test5.txt, and compare my solution with that of Optimizer.sol. 
I have four extra lines of code, located at lines 6-9.

Now, I must finish this up, as it is 11:50PM.

Sincerely,
Alex
