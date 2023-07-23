
.section .text
.global _start

_start :
   test_10 :
       li x17, 1179
       li x22, 1724
       and x29, x17, x22
       li x23, 1176
       bne x29, x23, _bad
   test_11 :
       li x17, 3561
       li x6, 997
       and x29, x17, x6
       li x23, 481
       bne x29, x23, _bad
   _exit :
       j _good
