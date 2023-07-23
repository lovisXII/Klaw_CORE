
.section .text
.global _start

_start :
   test_6 :
       li x17, 431
       ori x29, x17, 1026
       li x23,1455
       bne x29, x23, _bad
   test_7 :
       li x17, 454
       ori x29, x17, 1721
       li x23,2047
       bne x29, x23, _bad
   _exit :
       j _good
