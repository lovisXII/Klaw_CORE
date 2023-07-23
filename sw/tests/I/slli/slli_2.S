
.section .text
.global _start

_start :
   test_4 :
       li x17, 3106
       slli x29, x17, 3324
       li x23,536870912
       bne x29, x23, _bad
   test_5 :
       li x17, 1508
       slli x29, x17, 3174
       li x23,96512
       bne x29, x23, _bad
   _exit :
       j _good
