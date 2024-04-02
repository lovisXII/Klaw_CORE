
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 137
       slti x29, x17, 1748
       li x23,1
       bne x29, x23, _bad
   test_1 :
       li x17, 1974
       slti x29, x17, 99
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
