
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 350
       li x31, 843
       slt x29, x17, x31
       li x23, 1
       bne x29, x23, _bad
   test_19 :
       li x17, 889
       li x16, 3939
       slt x29, x17, x16
       li x23, 1
       bne x29, x23, _bad
   _exit :
       j _good
