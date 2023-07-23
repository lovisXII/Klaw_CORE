
.section .text
.global _start

_start :
   test_2 :
       li x17, 2417
       srli x29, x17, 2123
       li x23,1
       bne x29, x23, _bad
   test_3 :
       li x17, 1998
       srli x29, x17, 2106
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
