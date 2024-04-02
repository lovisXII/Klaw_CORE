
.section .text.init
.global _start

_start :
   test_8 :
       li x17, 3634
       li x21, 3927
       and x29, x17, x21
       li x23, 3602
       bne x29, x23, _bad
   test_9 :
       li x17, 2116
       li x8, 2798
       and x29, x17, x8
       li x23, 2116
       bne x29, x23, _bad
   _exit :
       j _good
