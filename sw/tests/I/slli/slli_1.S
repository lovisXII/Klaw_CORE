
.section .text
.global _start

_start :
   test_2 :
       li x17, 2940
       slli x29, x17, 1984
       li x23,2940
       bne x29, x23, _bad
   test_3 :
       li x17, 1660
       slli x29, x17, 699
       li x23,-536870912
       bne x29, x23, _bad
   _exit :
       j _good
