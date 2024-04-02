
.section .text.init
.global _start

_start :
   test_8 :
       li x17, 3785
       xori x29, x17, 2602
       li x23,1251
       bne x29, x23, _bad
   test_9 :
       li x17, 1241
       xori x29, x17, 3605
       li x23,2764
       bne x29, x23, _bad
   _exit :
       j _good
