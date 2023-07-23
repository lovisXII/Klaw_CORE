
.section .text
.global _start

_start :
   test_10 :
       li x17, 1530
       li x22, 3019
       xor x29, x17, x22
       li x23, 3633
       bne x29, x23, _bad
   test_11 :
       li x17, 2156
       li x6, 3333
       xor x29, x17, x6
       li x23, 1385
       bne x29, x23, _bad
   _exit :
       j _good
