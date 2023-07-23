
.section .text
.global _start

_start :
   test_12 :
       li x17, 1573
       li x17, 3791
       and x29, x17, x17
       li x23, 3791
       bne x29, x23, _bad
   test_13 :
       li x17, 520
       li x30, 3573
       and x29, x17, x30
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
