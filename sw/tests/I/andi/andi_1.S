
.section .text.init
.global _start

_start :
   test_2 :
       li x17, 2258
       andi x29, x17, 408
       li x23,144
       bne x29, x23, _bad
   test_3 :
       li x17, 1867
       andi x29, x17, 3125
       li x23,1025
       bne x29, x23, _bad
   _exit :
       j _good
