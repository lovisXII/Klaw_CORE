
.section .text.init
.global _start

_start :
   test_16 :
       li x17, 1397
       li x4, 4056
       sll x29, x17, x4
       li x23, 1962934272
       bne x29, x23, _bad
   test_17 :
       li x17, 1470
       li x23, 2145
       sll x29, x17, x23
       li x23, 2940
       bne x29, x23, _bad
   _exit :
       j _good
