
.section .text
.global _start

_start :
   test_0 :
       li x17, 3337
       li x1, 834
       sra x29, x17, x1
       li x23, 834
       bne x29, x23, _bad
   test_1 :
       li x17, 997
       li x3, 2054
       sra x29, x17, x3
       li x23, 15
       bne x29, x23, _bad
   _exit :
       j _good
