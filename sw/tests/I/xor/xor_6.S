
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 2732
       li x17, 1158
       xor x29, x17, x17
       li x23, 0
       bne x29, x23, _bad
   test_13 :
       li x17, 3617
       li x30, 2603
       xor x29, x17, x30
       li x23, 1034
       bne x29, x23, _bad
   _exit :
       j _good
