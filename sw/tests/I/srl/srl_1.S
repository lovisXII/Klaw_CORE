
.section .text.init
.global _start

_start :
   test_2 :
       li x17, 3298
       li x2, 3312
       srl x29, x17, x2
       li x23, 0
       bne x29, x23, _bad
   test_3 :
       li x17, 996
       li x29, 2718
       srl x29, x17, x29
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
