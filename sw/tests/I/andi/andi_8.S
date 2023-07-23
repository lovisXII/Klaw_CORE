
.section .text
.global _start

_start :
   test_16 :
       li x17, 3868
       andi x29, x17, 2643
       li x23,2576
       bne x29, x23, _bad
   test_17 :
       li x17, 3354
       andi x29, x17, 2030
       li x23,1290
       bne x29, x23, _bad
   _exit :
       j _good
