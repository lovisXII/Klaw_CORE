
.section .text
.global _start

_start :
   test_12 :
       li x17, 916
       li x17, 1025
       or x29, x17, x17
       li x23, 1025
       bne x29, x23, _bad
   test_13 :
       li x17, 2494
       li x30, 436
       or x29, x17, x30
       li x23, 2494
       bne x29, x23, _bad
   _exit :
       j _good
