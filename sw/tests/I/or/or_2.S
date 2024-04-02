
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 1689
       li x26, 2128
       or x29, x17, x26
       li x23, 3801
       bne x29, x23, _bad
   test_5 :
       li x17, 2467
       li x28, 739
       or x29, x17, x28
       li x23, 3043
       bne x29, x23, _bad
   _exit :
       j _good
