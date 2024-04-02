
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 1965
       li x19, 1236
       sra x29, x17, x19
       li x23, 0
       bne x29, x23, _bad
   test_7 :
       li x17, 1910
       li x12, 3655
       sra x29, x17, x12
       li x23, 14
       bne x29, x23, _bad
   _exit :
       j _good
