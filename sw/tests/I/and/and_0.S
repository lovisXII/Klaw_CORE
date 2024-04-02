
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 1386
       li x1, 894
       and x29, x17, x1
       li x23, 362
       bne x29, x23, _bad
   test_1 :
       li x17, 332
       li x3, 382
       and x29, x17, x3
       li x23, 332
       bne x29, x23, _bad
   _exit :
       j _good
