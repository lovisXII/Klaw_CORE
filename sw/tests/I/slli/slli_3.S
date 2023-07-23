
.section .text
.global _start

_start :
   test_6 :
       li x17, 4058
       slli x29, x17, 2657
       li x23,8116
       bne x29, x23, _bad
   test_7 :
       li x17, 3083
       slli x29, x17, 99
       li x23,24664
       bne x29, x23, _bad
   _exit :
       j _good
