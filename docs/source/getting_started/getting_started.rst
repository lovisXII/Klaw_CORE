Getting Started
===============

Installation
------------

To setup all the dependencies you will need a couple of bash script. And of course you will need a linux distribution. The code have been runned under the following distribution :
* Ubuntu 22.04
* WSL2 (Windows Subsytem for Linux)

It should work on other Unix distributions but some modification may be needed on the scripts.\
To setup your environment please run :

.. code-block:: bash

    source setup.sh
    ./setup-riscof.sh

After that you're suppose to be good to go. If not please raise an issue.

How to launch the simulation 
----------------------------

| We are using a plateform named ``core_tb.cpp``, written in c++, to simulate our design. The entire RTL is compiled using `verilator <https://www.veripool.org/verilator/>`_.
| The simulation plateform is using the ``systemC`` library, this is why we need to generate sysmteC when using verilator.

| We are using a makefile to build and run the simulation, here's are the usefull commands :


.. code-block:: bash

    make core_tb                 # build the design
    make run                     # run a default test
    make run TEST=path/test_name # run the custom test given in argument

Calling only `make core_tb` will create the `obj_dir` directory that contains all the data from verilator. The binary that allow to simulate the design is located in `obj_dir/Vcore`.

core_tb options
^^^^^^^^^^^^^^^

| To launch manually the simulation you have to run `obj_dir/Vcore test_filename [options]`.
| The core_tb offers severals options, you can print all of it by running `obj_dir/Vcore --help`, here's the list of all the available options :

- **-O** : Compile test_filename using the -O flag from gcc
- **--riscof signature_filename** : Allow to enable the riscof gestion and store the signature in the file named signature_filename
- **--riscof signature_filename --debug** : Allow to visualise all the store made by the cpu
- **--stats** : Allow to use the statistic such as the number of cycle needed to end the program

You will find more information about the core_tb itself in the following section : :ref:`verif-ref`