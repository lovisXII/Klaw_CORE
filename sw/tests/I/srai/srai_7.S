
.section .text
.global _start

_start :
   test_14 :
       li x17, 700
       srai x29, x17, 423
       li x23,-1
       bne x29, x23, _bad
   test_15 :
       li x17, 2829
       srai x29, x17, 702
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
