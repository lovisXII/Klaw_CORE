
.section .text
.global _start

_start :
   test_0 :
       li x17, 293
       li x1, 2397
       sub x29, x17, x1
       li x23, -2104
       bne x29, x23, _bad
   test_1 :
       li x17, 261
       li x3, 791
       sub x29, x17, x3
       li x23, -530
       bne x29, x23, _bad
   _exit :
       j _good
