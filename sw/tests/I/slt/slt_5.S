
.section .text.init
.global _start

_start :
   test_10 :
       li x17, 328
       li x22, 583
       slt x29, x17, x22
       li x23, 1
       bne x29, x23, _bad
   test_11 :
       li x17, 1892
       li x6, 1725
       slt x29, x17, x6
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
