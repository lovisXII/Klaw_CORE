
.section .text.init
.global _start

_start :
   test_2 :
       li x17, 3801
       li x2, 2151
       or x29, x17, x2
       li x23, 3839
       bne x29, x23, _bad
   test_3 :
       li x17, 3123
       li x29, 2999
       or x29, x17, x29
       li x23, 4023
       bne x29, x23, _bad
   _exit :
       j _good
