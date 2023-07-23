
.section .text
.global _start

_start :
   test_2 :
       li x17, 2897
       li x2, 3877
       and x29, x17, x2
       li x23, 2817
       bne x29, x23, _bad
   test_3 :
       li x17, 2995
       li x29, 2888
       and x29, x17, x29
       li x23, 2816
       bne x29, x23, _bad
   _exit :
       j _good
