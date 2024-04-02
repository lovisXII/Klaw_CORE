
.section .text.init
.global _start

_start :
   test_14 :
       li x17, 915
       slli x29, x17, 4012
       li x23,3747840
       bne x29, x23, _bad
   test_15 :
       li x17, 519
       slli x29, x17, 3871
       li x23,-2147483648
       bne x29, x23, _bad
   _exit :
       j _good
