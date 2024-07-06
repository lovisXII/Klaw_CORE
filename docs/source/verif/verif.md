.. _verif-ref:

# Verification

## Custom programms

Our test-bench is abled to run any type of **RV32IZicsr** assembly, c or elf files. But you need to ensure some things to be sure the programm with run successfully.\
Any files must start with the following lines of code :
```s
.section .text
.global _start

_start :
you code here
```
And and the end of the program you need to jump to ``_good`` if the programm ran successfully or jump to ``_bad`` if it didn't. Here's a quick example :
```s
.section .text
.global _start

_start :
       li x17, 1383
       li x1, 966
       add x29, x17, x1
       li x23, 2349
       bne x29, x23, _bad
       j _good
```
The previus program is performing an addition and if the result is correct it jumps to _good otherwise to _bad.
For C files it is quite the same things, you need to call the __asm__ macro :
```c
extern void _bad();
extern void _good();

__asm__(".section .text") ;
__asm__(".global _start") ;

__asm__("_start:");
__asm__("addi x1,x1, 4");
__asm__("sub x2, x2,x1 "); // Initialise the stack
__asm__("jal x5, main");
int main() {
    // Your code here
    (success) ? good() : bad(); //jump either to good or bad depending on the success
}
```
You may not call the ``_good`` or ``_bad`` label, but if you do not when you program will arrive to the end it will juste execute nothing and after a maximum numbers of cycle the program will be terminated by the test-bench.
