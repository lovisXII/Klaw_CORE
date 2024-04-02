
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 900
       li x26, 2899
       and x29, x17, x26
       li x23, 768
       bne x29, x23, _bad
   test_5 :
       li x17, 314
       li x28, 1172
       and x29, x17, x28
       li x23, 16
       bne x29, x23, _bad
   _exit :
       j _good
