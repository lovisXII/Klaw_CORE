
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 1531
       li x17, 1321
       sll x29, x17, x17
       li x23, 676352
       bne x29, x23, _bad
   test_13 :
       li x17, 3537
       li x30, 4070
       sll x29, x17, x30
       li x23, 226368
       bne x29, x23, _bad
   _exit :
       j _good
