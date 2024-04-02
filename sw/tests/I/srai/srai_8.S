
.section .text.init
.global _start

_start :
   test_16 :
       li x17, 1435
       srai x29, x17, 3263
       li x23,-1
       bne x29, x23, _bad
   test_17 :
       li x17, 939
       srai x29, x17, 1550
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
