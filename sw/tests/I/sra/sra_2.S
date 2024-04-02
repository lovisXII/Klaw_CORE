
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 3747
       li x26, 3460
       sra x29, x17, x26
       li x23, 234
       bne x29, x23, _bad
   test_5 :
       li x17, 3711
       li x28, 1069
       sra x29, x17, x28
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
