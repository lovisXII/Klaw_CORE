
.section .text
.global _start

_start :
   test_2 :
       li x17, 358
       addi x29, x17, 2690
       li x23,3048
       bne x29, x23, _bad
   test_3 :
       li x17, 868
       addi x29, x17, 3992
       li x23,4860
       bne x29, x23, _bad
   _exit :
       j _good
