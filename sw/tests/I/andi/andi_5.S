
.section .text
.global _start

_start :
   test_10 :
       li x17, 1555
       andi x29, x17, 4079
       li x23,1539
       bne x29, x23, _bad
   test_11 :
       li x17, 997
       andi x29, x17, 800
       li x23,800
       bne x29, x23, _bad
   _exit :
       j _good
