
.section .text
.global _start

_start :
   test_10 :
       li x17, 1313
       li x22, 3389
       sub x29, x17, x22
       li x23, -2076
       bne x29, x23, _bad
   test_11 :
       li x17, 3548
       li x6, 135
       sub x29, x17, x6
       li x23, 3413
       bne x29, x23, _bad
   _exit :
       j _good
