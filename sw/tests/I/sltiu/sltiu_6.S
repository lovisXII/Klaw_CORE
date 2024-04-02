
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 110
       sltiu x29, x17, 1283
       li x23,-1
       bne x29, x23, _bad
   test_13 :
       li x17, 3624
       sltiu x29, x17, 730
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
