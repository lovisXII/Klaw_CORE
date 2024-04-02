
.section .text.init
.global _start

_start :
   test_14 :
       li x17, 2198
       slti x29, x17, 1985
       li x23,0
       bne x29, x23, _bad
   test_15 :
       li x17, 1780
       slti x29, x17, 2335
       li x23,1
       bne x29, x23, _bad
   _exit :
       j _good
