
.section .text
.global _start

_start :
   test_2 :
       li x17, 2577
       li x2, 158
       sltu x29, x17, x2
       li x23, 0
       bne x29, x23, _bad
   test_3 :
       li x17, 265
       li x29, 2524
       sltu x29, x17, x29
       li x23, 1
       bne x29, x23, _bad
   _exit :
       j _good
