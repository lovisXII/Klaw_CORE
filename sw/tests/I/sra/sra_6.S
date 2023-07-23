
.section .text
.global _start

_start :
   test_12 :
       li x17, 3616
       li x17, 2083
       sra x29, x17, x17
       li x23, 260
       bne x29, x23, _bad
   test_13 :
       li x17, 1669
       li x30, 1388
       sra x29, x17, x30
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
