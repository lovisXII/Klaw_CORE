
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 455
       srli x29, x17, 859
       li x23,0
       bne x29, x23, _bad
   test_19 :
       li x17, 3492
       srli x29, x17, 1084
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
