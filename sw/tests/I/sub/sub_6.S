
.section .text
.global _start

_start :
   test_12 :
       li x17, 2672
       li x17, 3561
       sub x29, x17, x17
       li x23, 0
       bne x29, x23, _bad
   test_13 :
       li x17, 2110
       li x30, 1185
       sub x29, x17, x30
       li x23, 925
       bne x29, x23, _bad
   _exit :
       j _good
