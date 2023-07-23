
.section .text
.global _start

_start :
   test_16 :
       li x17, 4084
       li x4, 3052
       sra x29, x17, x4
       li x23, 0
       bne x29, x23, _bad
   test_17 :
       li x17, 2827
       li x23, 2233
       sra x29, x17, x23
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
