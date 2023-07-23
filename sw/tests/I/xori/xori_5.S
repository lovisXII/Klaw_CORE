
.section .text
.global _start

_start :
   test_10 :
       li x17, 2817
       xori x29, x17, 1091
       li x23,3906
       bne x29, x23, _bad
   test_11 :
       li x17, 1583
       xori x29, x17, 2286
       li x23,3777
       bne x29, x23, _bad
   _exit :
       j _good
