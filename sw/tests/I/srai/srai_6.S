
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 1290
       srai x29, x17, 3937
       li x23,-1
       bne x29, x23, _bad
   test_13 :
       li x17, 1027
       srai x29, x17, 1745
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
