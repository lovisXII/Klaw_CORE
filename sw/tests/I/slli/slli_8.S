
.section .text
.global _start

_start :
   test_16 :
       li x17, 696
       slli x29, x17, 1901
       li x23,5701632
       bne x29, x23, _bad
   test_17 :
       li x17, 3345
       slli x29, x17, 3636
       li x23,-787480576
       bne x29, x23, _bad
   _exit :
       j _good
