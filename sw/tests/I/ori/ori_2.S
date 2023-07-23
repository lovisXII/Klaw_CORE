
.section .text
.global _start

_start :
   test_4 :
       li x17, 142
       ori x29, x17, 1569
       li x23,1711
       bne x29, x23, _bad
   test_5 :
       li x17, 46
       ori x29, x17, 813
       li x23,815
       bne x29, x23, _bad
   _exit :
       j _good
