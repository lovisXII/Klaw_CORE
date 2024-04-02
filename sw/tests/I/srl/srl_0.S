
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 3894
       li x1, 148
       srl x29, x17, x1
       li x23, 0
       bne x29, x23, _bad
   test_1 :
       li x17, 691
       li x3, 2479
       srl x29, x17, x3
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
