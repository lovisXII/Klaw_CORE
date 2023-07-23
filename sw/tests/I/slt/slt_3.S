
.section .text
.global _start

_start :
   test_6 :
       li x17, 1257
       li x19, 2721
       slt x29, x17, x19
       li x23, 1
       bne x29, x23, _bad
   test_7 :
       li x17, 570
       li x12, 2789
       slt x29, x17, x12
       li x23, 1
       bne x29, x23, _bad
   _exit :
       j _good
