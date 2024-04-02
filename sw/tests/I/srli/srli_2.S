
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 629
       srli x29, x17, 3239
       li x23,4
       bne x29, x23, _bad
   test_5 :
       li x17, 1615
       srli x29, x17, 3446
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
