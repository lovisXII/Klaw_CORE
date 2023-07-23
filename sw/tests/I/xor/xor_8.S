
.section .text
.global _start

_start :
   test_16 :
       li x17, 3518
       li x4, 3184
       xor x29, x17, x4
       li x23, 462
       bne x29, x23, _bad
   test_17 :
       li x17, 437
       li x23, 883
       xor x29, x17, x23
       li x23, 710
       bne x29, x23, _bad
   _exit :
       j _good
