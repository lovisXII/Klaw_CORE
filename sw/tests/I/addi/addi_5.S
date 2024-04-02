
.section .text.init
.global _start

_start :
   test_10 :
       li x17, 68
       addi x29, x17, 734
       li x23,802
       bne x29, x23, _bad
   test_11 :
       li x17, 1148
       addi x29, x17, 4005
       li x23,5153
       bne x29, x23, _bad
   _exit :
       j _good
