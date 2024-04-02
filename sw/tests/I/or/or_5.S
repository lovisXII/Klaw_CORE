
.section .text.init
.global _start

_start :
   test_10 :
       li x17, 272
       li x22, 1960
       or x29, x17, x22
       li x23, 1976
       bne x29, x23, _bad
   test_11 :
       li x17, 2294
       li x6, 261
       or x29, x17, x6
       li x23, 2551
       bne x29, x23, _bad
   _exit :
       j _good
