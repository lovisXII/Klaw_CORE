
.section .text
.global _start

_start :
   test_0 :
       li x17, 1598
       li x1, 2565
       or x29, x17, x1
       li x23, 3647
       bne x29, x23, _bad
   test_1 :
       li x17, 241
       li x3, 3564
       or x29, x17, x3
       li x23, 3581
       bne x29, x23, _bad
   _exit :
       j _good
