Exe
---

The EXE (execute) stage is in charge of executing the instruction and producing a result.
To do so it may use the following stages :

#. **ALU** (arithmetic logic unit), which can perform the following operation :

    #. Addition
    #. Comparaison
    #. Logic operations (and, or, xor)

#. **Shifter** which can perform the logical and arithmetical shift
#. **BU** (branch unit) which calculate the new pc and determine if a branch may succeed or not (in case of a conditionnal branch)
#. **LSU** (Load store unit) which compute the address of a load/store and then send it to top (exe.sv)

All the units are in parallel bot none of them are actually able to work in parallel. We have
design this that way because we want to enable a parallel computation in in the future
but for now it's indeed not optimal.

Each unit has an enable bits and the final result is collected thanks to a Mux.
Once the result is collected it's flopped and sent write back.

If a flush occur a bit is set in exe to inform the stage that the next 2 instructions it will receive must be flushed.
