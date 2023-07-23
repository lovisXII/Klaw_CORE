
.section .text
.global _start

_start :
   test_0 :
       li x17, 2956
       slli x29, x17, 780
       li x23,12107776
       bne x29, x23, _bad
   test_1 :
       li x17, 1382
       slli x29, x17, 3569
       li x23,181141504
       bne x29, x23, _bad
   _exit :
       j _good
