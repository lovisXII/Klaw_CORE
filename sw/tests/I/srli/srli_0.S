
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 1086
       srli x29, x17, 4011
       li x23,0
       bne x29, x23, _bad
   test_1 :
       li x17, 3145
       srli x29, x17, 1487
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
