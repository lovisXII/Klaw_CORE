
.section .text
.global _start

_start :
   test_4 :
       li x17, 1025
       srai x29, x17, 3917
       li x23,-1
       bne x29, x23, _bad
   test_5 :
       li x17, 496
       srai x29, x17, 1536
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
