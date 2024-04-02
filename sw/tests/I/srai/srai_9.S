
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 1237
       srai x29, x17, 1688
       li x23,-1
       bne x29, x23, _bad
   test_19 :
       li x17, 1025
       srai x29, x17, 2262
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
