
.section .text.init
.global _start

_start :
   test_14 :
       li x17, 1820
       li x24, 3707
       slt x29, x17, x24
       li x23, 1
       bne x29, x23, _bad
   test_15 :
       li x17, 1380
       li x20, 3525
       slt x29, x17, x20
       li x23, 1
       bne x29, x23, _bad
   _exit :
       j _good
