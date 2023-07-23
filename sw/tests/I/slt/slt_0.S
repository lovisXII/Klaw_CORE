
.section .text
.global _start

_start :
   test_0 :
       li x17, 1704
       li x1, 3225
       slt x29, x17, x1
       li x23, 1
       bne x29, x23, _bad
   test_1 :
       li x17, 1551
       li x3, 149
       slt x29, x17, x3
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
