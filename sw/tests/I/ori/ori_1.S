
.section .text
.global _start

_start :
   test_2 :
       li x17, 1405
       ori x29, x17, 2622
       li x23,3967
       bne x29, x23, _bad
   test_3 :
       li x17, 1989
       ori x29, x17, 534
       li x23,2007
       bne x29, x23, _bad
   _exit :
       j _good
