
.section .text
.global _start

_start :
   test_18 :
       li x17, 2380
       sltiu x29, x17, 1401
       li x23,-1
       bne x29, x23, _bad
   test_19 :
       li x17, 139
       sltiu x29, x17, 3072
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
