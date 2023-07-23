
.section .text
.global _start

_start :
   test_8 :
       li x17, 3457
       srli x29, x17, 3051
       li x23,1
       bne x29, x23, _bad
   test_9 :
       li x17, 3169
       srli x29, x17, 1021
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
