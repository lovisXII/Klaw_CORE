
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 3589
       li x26, 3567
       slt x29, x17, x26
       li x23, 0
       bne x29, x23, _bad
   test_5 :
       li x17, 3063
       li x28, 3840
       slt x29, x17, x28
       li x23, 1
       bne x29, x23, _bad
   _exit :
       j _good
