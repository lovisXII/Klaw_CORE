
.section .text
.global _start

_start :
   test_12 :
       li x17, 543
       li x17, 3363
       slt x29, x17, x17
       li x23, 0
       bne x29, x23, _bad
   test_13 :
       li x17, 3870
       li x30, 3752
       slt x29, x17, x30
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
