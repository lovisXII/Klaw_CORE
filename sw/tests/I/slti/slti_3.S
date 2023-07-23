
.section .text
.global _start

_start :
   test_6 :
       li x17, 2541
       slti x29, x17, 406
       li x23,0
       bne x29, x23, _bad
   test_7 :
       li x17, 3858
       slti x29, x17, 2028
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
