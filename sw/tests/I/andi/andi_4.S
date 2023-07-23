
.section .text
.global _start

_start :
   test_8 :
       li x17, 1980
       andi x29, x17, 3831
       li x23,1716
       bne x29, x23, _bad
   test_9 :
       li x17, 3309
       andi x29, x17, 2782
       li x23,2252
       bne x29, x23, _bad
   _exit :
       j _good
