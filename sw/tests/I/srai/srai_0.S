
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 2
       srai x29, x17, 1012
       li x23,-1
       bne x29, x23, _bad
   test_1 :
       li x17, 434
       srai x29, x17, 237
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
