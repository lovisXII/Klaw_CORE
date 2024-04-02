
.section .text.init
.global _start

_start :
   test_8 :
       li x17, 867
       ori x29, x17, 1481
       li x23,2027
       bne x29, x23, _bad
   test_9 :
       li x17, 3466
       ori x29, x17, 1567
       li x23,3999
       bne x29, x23, _bad
   _exit :
       j _good
