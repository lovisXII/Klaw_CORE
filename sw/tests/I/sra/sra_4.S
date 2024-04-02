
.section .text.init
.global _start

_start :
   test_8 :
       li x17, 3294
       li x21, 3634
       sra x29, x17, x21
       li x23, 0
       bne x29, x23, _bad
   test_9 :
       li x17, 3100
       li x8, 3564
       sra x29, x17, x8
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
