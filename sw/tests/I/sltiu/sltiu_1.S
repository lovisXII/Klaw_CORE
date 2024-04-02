
.section .text.init
.global _start

_start :
   test_2 :
       li x17, 3756
       sltiu x29, x17, 3194
       li x23,-1
       bne x29, x23, _bad
   test_3 :
       li x17, 2726
       sltiu x29, x17, 1010
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
