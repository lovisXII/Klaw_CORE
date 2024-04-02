
.section .text.init
.global _start

_start :
   test_8 :
       li x17, 3635
       li x21, 1997
       sltu x29, x17, x21
       li x23, 0
       bne x29, x23, _bad
   test_9 :
       li x17, 3811
       li x8, 1360
       sltu x29, x17, x8
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
