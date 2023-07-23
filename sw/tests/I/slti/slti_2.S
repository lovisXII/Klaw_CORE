
.section .text
.global _start

_start :
   test_4 :
       li x17, 2596
       slti x29, x17, 3715
       li x23,1
       bne x29, x23, _bad
   test_5 :
       li x17, 2663
       slti x29, x17, 216
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
