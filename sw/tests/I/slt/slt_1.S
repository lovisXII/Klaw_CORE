
.section .text
.global _start

_start :
   test_2 :
       li x17, 1969
       li x2, 1515
       slt x29, x17, x2
       li x23, 0
       bne x29, x23, _bad
   test_3 :
       li x17, 1265
       li x29, 179
       slt x29, x17, x29
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
