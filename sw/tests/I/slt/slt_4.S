
.section .text.init
.global _start

_start :
   test_8 :
       li x17, 4042
       li x21, 11
       slt x29, x17, x21
       li x23, 0
       bne x29, x23, _bad
   test_9 :
       li x17, 2763
       li x8, 4048
       slt x29, x17, x8
       li x23, 1
       bne x29, x23, _bad
   _exit :
       j _good
