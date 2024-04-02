
.section .text.init
.global _start

_start :
   test_2 :
       li x17, 114
       srai x29, x17, 2070
       li x23,-1
       bne x29, x23, _bad
   test_3 :
       li x17, 748
       srai x29, x17, 3571
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
