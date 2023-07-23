
.section .text
.global _start

_start :
   test_18 :
       li x17, 205
       xori x29, x17, 1137
       li x23,1212
       bne x29, x23, _bad
   test_19 :
       li x17, 357
       xori x29, x17, 3750
       li x23,4035
       bne x29, x23, _bad
   _exit :
       j _good
