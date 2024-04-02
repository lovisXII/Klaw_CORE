
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 3280
       li x31, 3717
       and x29, x17, x31
       li x23, 3200
       bne x29, x23, _bad
   test_19 :
       li x17, 1530
       li x16, 84
       and x29, x17, x16
       li x23, 80
       bne x29, x23, _bad
   _exit :
       j _good
