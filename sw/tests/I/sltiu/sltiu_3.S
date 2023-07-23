
.section .text
.global _start

_start :
   test_6 :
       li x17, 690
       sltiu x29, x17, 1218
       li x23,-1
       bne x29, x23, _bad
   test_7 :
       li x17, 311
       sltiu x29, x17, 3882
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
