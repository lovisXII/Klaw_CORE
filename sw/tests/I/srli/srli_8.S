
.section .text
.global _start

_start :
   test_16 :
       li x17, 3065
       srli x29, x17, 2428
       li x23,0
       bne x29, x23, _bad
   test_17 :
       li x17, 2956
       srli x29, x17, 1386
       li x23,2
       bne x29, x23, _bad
   _exit :
       j _good
