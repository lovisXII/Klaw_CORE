
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 3611
       li x19, 272
       sltu x29, x17, x19
       li x23, 0
       bne x29, x23, _bad
   test_7 :
       li x17, 2223
       li x12, 59
       sltu x29, x17, x12
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
