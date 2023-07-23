
.section .text
.global _start

_start :
   test_12 :
       li x17, 3191
       slti x29, x17, 1289
       li x23,0
       bne x29, x23, _bad
   test_13 :
       li x17, 1745
       slti x29, x17, 2981
       li x23,1
       bne x29, x23, _bad
   _exit :
       j _good
