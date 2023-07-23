
.section .text
.global _start

_start :
   test_10 :
       li x17, 1608
       li x22, 1095
       sltu x29, x17, x22
       li x23, 0
       bne x29, x23, _bad
   test_11 :
       li x17, 789
       li x6, 348
       sltu x29, x17, x6
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
