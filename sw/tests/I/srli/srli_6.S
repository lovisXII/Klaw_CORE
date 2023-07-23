
.section .text
.global _start

_start :
   test_12 :
       li x17, 3519
       srli x29, x17, 3341
       li x23,0
       bne x29, x23, _bad
   test_13 :
       li x17, 2793
       srli x29, x17, 3724
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
