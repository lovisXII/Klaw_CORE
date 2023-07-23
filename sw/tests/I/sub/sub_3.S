
.section .text
.global _start

_start :
   test_6 :
       li x17, 1691
       li x19, 3764
       sub x29, x17, x19
       li x23, -2073
       bne x29, x23, _bad
   test_7 :
       li x17, 1108
       li x12, 1553
       sub x29, x17, x12
       li x23, -445
       bne x29, x23, _bad
   _exit :
       j _good
