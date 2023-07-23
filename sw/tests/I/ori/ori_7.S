
.section .text
.global _start

_start :
   test_14 :
       li x17, 801
       ori x29, x17, 1819
       li x23,1851
       bne x29, x23, _bad
   test_15 :
       li x17, 769
       ori x29, x17, 2311
       li x23,2823
       bne x29, x23, _bad
   _exit :
       j _good
