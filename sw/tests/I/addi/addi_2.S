
.section .text
.global _start

_start :
   test_4 :
       li x17, 2521
       addi x29, x17, 2984
       li x23,5505
       bne x29, x23, _bad
   test_5 :
       li x17, 2695
       addi x29, x17, 3701
       li x23,6396
       bne x29, x23, _bad
   _exit :
       j _good
