
.section .text
.global _start

_start :
   test_16 :
       li x17, 3913
       li x4, 3945
       or x29, x17, x4
       li x23, 3945
       bne x29, x23, _bad
   test_17 :
       li x17, 230
       li x23, 3619
       or x29, x17, x23
       li x23, 3815
       bne x29, x23, _bad
   _exit :
       j _good
