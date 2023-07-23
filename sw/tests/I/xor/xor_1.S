
.section .text
.global _start

_start :
   test_2 :
       li x17, 1461
       li x2, 2762
       xor x29, x17, x2
       li x23, 3967
       bne x29, x23, _bad
   test_3 :
       li x17, 1870
       li x29, 1000
       xor x29, x17, x29
       li x23, 1190
       bne x29, x23, _bad
   _exit :
       j _good
