
.section .text
.global _start

_start :
   test_10 :
       li x17, 1509
       slti x29, x17, 1290
       li x23,0
       bne x29, x23, _bad
   test_11 :
       li x17, 2040
       slti x29, x17, 2205
       li x23,1
       bne x29, x23, _bad
   _exit :
       j _good
