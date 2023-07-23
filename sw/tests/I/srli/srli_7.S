
.section .text
.global _start

_start :
   test_14 :
       li x17, 382
       srli x29, x17, 3150
       li x23,0
       bne x29, x23, _bad
   test_15 :
       li x17, 3378
       srli x29, x17, 1469
       li x23,0
       bne x29, x23, _bad
   _exit :
       j _good
