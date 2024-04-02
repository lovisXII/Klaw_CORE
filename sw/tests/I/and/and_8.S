
.section .text.init
.global _start

_start :
   test_16 :
       li x17, 3936
       li x4, 3498
       and x29, x17, x4
       li x23, 3360
       bne x29, x23, _bad
   test_17 :
       li x17, 722
       li x23, 2738
       and x29, x17, x23
       li x23, 658
       bne x29, x23, _bad
   _exit :
       j _good
