
Micro Architecture
==================

| This section describes the micro architecture of the core and gives some explanation about the design choices.
| The core is a 4 stages pipeline in order micro architecture. It is designed using system verilog and it composed of the following stages :

- **IFetch**
- **Decod**
- **Exe**
- **Write back**

IFetch
------

This stage is responsible of the fetch of the instruction and the fetch of the 1st instruction after the reset.

Reset
^^^^^

| The reset we are using is a negative reset, it means it is active on low value. One of the role of Ifetch is to fetch the first instruction after the reset.
| Thus Ifetch has to detect the end of the reset and when it is valid it must fetch the first instruction.  
| The boot address is written in the signal `reset_adr_i`, which is an interface of the core.
| The stage contains an adder to calculate the next PC. We have to do this because since the PC is calculated in EXE, during the first 3 cycles EXE will not send the new PC to fetch.
| The below timing diagram illustrate this behavior

.. image:: ../image/reset_waves.png
  :width: 400
  :alt: Alternative text

On this diagramm we have :

- ``clk``              : the clock
- ``reset_n``          : the reset signal
- ``end_reset_signal`` : a valid bit that indicate the end of the reset
- ``reset_adr_i``      : contains the reset address to fetch
- ``pc_data_i``        : the pc sent by exe

During the first two cycles the reset is active and thus nothing should happen.
Then on the **3d** cycle the reset end and thus the first instruction is fetched
using the address sent by ``reset_adr_i``. So it's only during **5th** cycle that
``EXE`` receive the first instruction, thus the next PC will be calculated only during the 5th cycle.
But since the output of ``EXE`` are flopped the information of the next PC will only arrive in Ifetch during the
6th cycle.
| This is to avoid this waiste of time that we are using an adder in Ifetch to calculate the next PC.

Next instruction
^^^^^^^^^^^^^^^^

| In a normal situation, i.e. when reset is done, Ifetch receives the programm counter (PC) from EXE and fetch the next instruction. 
| If a branch occur ``flush_v_q_i`` is set to 1 and Ifetch will not take the sequential PC it has estimated but instead it will takes the PC calculated by EXE. 

Interface with the memory
^^^^^^^^^^^^^^^^^^^^^^^^^

| The core is not using any cache for now, so is it directly connected to the memory which is emulated thanks to a map in the core_tb plateform.
| In the future we may add a latency to access the memory and add cache to compare the gain of performance.

Decod
-----

Description of Decod...

Exe
---

Description of Exe...

Write Back
----------

Description of Write Back...
