
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 1935
       li x1, 1080
       sll x29, x17, x1
       li x23, -1895825408
       bne x29, x23, _bad
   test_1 :
       li x17, 2140
       li x3, 3626
       sll x29, x17, x3
       li x23, 2191360
       bne x29, x23, _bad
   _exit :
       j _good
