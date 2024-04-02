
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 3499
       li x26, 3250
       sub x29, x17, x26
       li x23, 249
       bne x29, x23, _bad
   test_5 :
       li x17, 205
       li x28, 198
       sub x29, x17, x28
       li x23, 7
       bne x29, x23, _bad
   _exit :
       j _good
