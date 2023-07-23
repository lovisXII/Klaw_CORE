
.section .text
.global _start

_start :
   test_4 :
       li x17, 664
       li x26, 1586
       xor x29, x17, x26
       li x23, 1194
       bne x29, x23, _bad
   test_5 :
       li x17, 2360
       li x28, 2272
       xor x29, x17, x28
       li x23, 472
       bne x29, x23, _bad
   _exit :
       j _good
