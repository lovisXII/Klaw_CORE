
.section .text
.global _start

_start :
   test_14 :
       li x17, 3260
       li x24, 1348
       or x29, x17, x24
       li x23, 3580
       bne x29, x23, _bad
   test_15 :
       li x17, 3704
       li x20, 762
       or x29, x17, x20
       li x23, 3834
       bne x29, x23, _bad
   _exit :
       j _good
