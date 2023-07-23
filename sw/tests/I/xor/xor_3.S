
.section .text
.global _start

_start :
   test_6 :
       li x17, 2681
       li x19, 3149
       xor x29, x17, x19
       li x23, 1588
       bne x29, x23, _bad
   test_7 :
       li x17, 2621
       li x12, 2612
       xor x29, x17, x12
       li x23, 9
       bne x29, x23, _bad
   _exit :
       j _good
