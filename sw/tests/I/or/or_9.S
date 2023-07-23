
.section .text
.global _start

_start :
   test_18 :
       li x17, 2000
       li x31, 3354
       or x29, x17, x31
       li x23, 4058
       bne x29, x23, _bad
   test_19 :
       li x17, 2522
       li x16, 3689
       or x29, x17, x16
       li x23, 4091
       bne x29, x23, _bad
   _exit :
       j _good
