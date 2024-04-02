
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 234
       srli x29, x17, 3198
       li x23,0
       bne x29, x23, _bad
   test_7 :
       li x17, 1636
       srli x29, x17, 511
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
