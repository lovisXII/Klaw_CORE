
.section .text
.global _start

_start :
       li x1, 0
       li x2, 10
       li x3, 1
   loop :
       addi x1, x1, 1
       add x3, x3, x3
       bne x1, x2, loop
   _exit :
       j _good
