
.section .text
.global _start

_start :
   test_0 :
       li x17, 3811
       andi x29, x17, 1231
       li x23,1219
       bne x29, x23, _bad
   test_1 :
       li x17, 4050
       andi x29, x17, 146
       li x23,146
       bne x29, x23, _bad
   _exit :
       j _good
