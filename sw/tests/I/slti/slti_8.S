
.section .text.init
.global _start

_start :
   test_16 :
       li x17, 3733
       slti x29, x17, 3754
       li x23,1
       bne x29, x23, _bad
   test_17 :
       li x17, 2434
       slti x29, x17, 4042
       li x23,1
       bne x29, x23, _bad
   _exit :
       j _good
