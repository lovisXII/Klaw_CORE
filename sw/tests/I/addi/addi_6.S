
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 137
       addi x29, x17, 1870
       li x23,2007
       bne x29, x23, _bad
   test_13 :
       li x17, 2647
       addi x29, x17, 3417
       li x23,6064
       bne x29, x23, _bad
   _exit :
       j _good
