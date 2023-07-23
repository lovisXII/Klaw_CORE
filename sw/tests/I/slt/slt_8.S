
.section .text
.global _start

_start :
   test_16 :
       li x17, 2836
       li x4, 2931
       slt x29, x17, x4
       li x23, 1
       bne x29, x23, _bad
   test_17 :
       li x17, 3674
       li x23, 709
       slt x29, x17, x23
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
