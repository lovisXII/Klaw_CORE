
.section .text
.global _start

_start :
   test_10 :
       li x17, 510
       srli x29, x17, 707
       li x23,63
       bne x29, x23, _bad
   test_11 :
       li x17, 3483
       srli x29, x17, 1383
       li x23,27
       bne x29, x23, _bad
   _exit :
       j _good
