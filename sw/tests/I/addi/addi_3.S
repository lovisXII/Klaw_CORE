
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 613
       addi x29, x17, 2160
       li x23,2773
       bne x29, x23, _bad
   test_7 :
       li x17, 602
       addi x29, x17, 2186
       li x23,2788
       bne x29, x23, _bad
   _exit :
       j _good
