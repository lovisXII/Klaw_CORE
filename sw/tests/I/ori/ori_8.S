
.section .text
.global _start

_start :
   test_16 :
       li x17, 3341
       ori x29, x17, 472
       li x23,3549
       bne x29, x23, _bad
   test_17 :
       li x17, 253
       ori x29, x17, 651
       li x23,767
       bne x29, x23, _bad
   _exit :
       j _good
