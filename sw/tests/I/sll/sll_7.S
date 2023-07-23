
.section .text
.global _start

_start :
   test_14 :
       li x17, 5
       li x24, 316
       sll x29, x17, x24
       li x23, 1342177280
       bne x29, x23, _bad
   test_15 :
       li x17, 1916
       li x20, 1940
       sll x29, x17, x20
       li x23, 2009071616
       bne x29, x23, _bad
   _exit :
       j _good
