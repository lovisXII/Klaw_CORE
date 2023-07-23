
.section .text
.global _start

_start :
   test_8 :
       li x17, 4087
       li x21, 1118
       or x29, x17, x21
       li x23, 4095
       bne x29, x23, _bad
   test_9 :
       li x17, 4000
       li x8, 1522
       or x29, x17, x8
       li x23, 4082
       bne x29, x23, _bad
   _exit :
       j _good
