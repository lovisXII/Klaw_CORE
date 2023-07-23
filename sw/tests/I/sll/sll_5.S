
.section .text
.global _start

_start :
   test_10 :
       li x17, 251
       li x22, 1786
       sll x29, x17, x22
       li x23, -335544320
       bne x29, x23, _bad
   test_11 :
       li x17, 3754
       li x6, 826
       sll x29, x17, x6
       li x23, -1476395008
       bne x29, x23, _bad
   _exit :
       j _good
