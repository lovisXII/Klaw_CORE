
.section .text.init
.global _start

_start :
   test_2 :
       li x17, 748
       li x2, 3248
       sll x29, x17, x2
       li x23, 49020928
       bne x29, x23, _bad
   test_3 :
       li x17, 1083
       li x29, 1787
       sll x29, x17, x29
       li x23, -671088640
       bne x29, x23, _bad
   _exit :
       j _good
