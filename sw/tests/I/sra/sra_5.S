
.section .text.init
.global _start

_start :
   test_10 :
       li x17, 3146
       li x22, 964
       sra x29, x17, x22
       li x23, 196
       bne x29, x23, _bad
   test_11 :
       li x17, 3632
       li x6, 2806
       sra x29, x17, x6
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
