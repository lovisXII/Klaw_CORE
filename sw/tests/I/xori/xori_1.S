
.section .text
.global _start

_start :
   test_2 :
       li x17, 536
       xori x29, x17, 1489
       li x23,1993
       bne x29, x23, _bad
   test_3 :
       li x17, 1278
       xori x29, x17, 3044
       li x23,3866
       bne x29, x23, _bad
   _exit :
       j _good
