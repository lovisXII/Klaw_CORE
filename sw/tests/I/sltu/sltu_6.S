
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 4027
       li x17, 367
       sltu x29, x17, x17
       li x23, 0
       bne x29, x23, _bad
   test_13 :
       li x17, 1058
       li x30, 281
       sltu x29, x17, x30
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
