
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 401
       xori x29, x17, 2502
       li x23,2135
       bne x29, x23, _bad
   test_7 :
       li x17, 3073
       xori x29, x17, 511
       li x23,3582
       bne x29, x23, _bad
   _exit :
       j _good
