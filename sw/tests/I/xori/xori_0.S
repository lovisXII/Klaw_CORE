
.section .text
.global _start

_start :
   test_0 :
       li x17, 802
       xori x29, x17, 3414
       li x23,3700
       bne x29, x23, _bad
   test_1 :
       li x17, 1178
       xori x29, x17, 1492
       li x23,334
       bne x29, x23, _bad
   _exit :
       j _good
