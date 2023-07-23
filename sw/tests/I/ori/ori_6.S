
.section .text
.global _start

_start :
   test_12 :
       li x17, 1366
       ori x29, x17, 3209
       li x23,3551
       bne x29, x23, _bad
   test_13 :
       li x17, 794
       ori x29, x17, 2603
       li x23,2875
       bne x29, x23, _bad
   _exit :
       j _good
