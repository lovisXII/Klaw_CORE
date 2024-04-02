
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 2296
       li x1, 1188
       xor x29, x17, x1
       li x23, 3164
       bne x29, x23, _bad
   test_1 :
       li x17, 539
       li x3, 1811
       xor x29, x17, x3
       li x23, 1288
       bne x29, x23, _bad
   _exit :
       j _good
