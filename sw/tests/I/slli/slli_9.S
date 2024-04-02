
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 3885
       slli x29, x17, 909
       li x23,31825920
       bne x29, x23, _bad
   test_19 :
       li x17, 239
       slli x29, x17, 2895
       li x23,7831552
       bne x29, x23, _bad
   _exit :
       j _good
