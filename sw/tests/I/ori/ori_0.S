
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 1509
       ori x29, x17, 1522
       li x23,1527
       bne x29, x23, _bad
   test_1 :
       li x17, 3798
       ori x29, x17, 2038
       li x23,4086
       bne x29, x23, _bad
   _exit :
       j _good
