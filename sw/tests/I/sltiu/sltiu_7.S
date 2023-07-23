
.section .text
.global _start

_start :
   test_14 :
       li x17, 3916
       sltiu x29, x17, 215
       li x23,-1
       bne x29, x23, _bad
   test_15 :
       li x17, 3946
       sltiu x29, x17, 2073
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
