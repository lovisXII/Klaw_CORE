
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 455
       andi x29, x17, 1250
       li x23,194
       bne x29, x23, _bad
   test_13 :
       li x17, 1451
       andi x29, x17, 3549
       li x23,1417
       bne x29, x23, _bad
   _exit :
       j _good
