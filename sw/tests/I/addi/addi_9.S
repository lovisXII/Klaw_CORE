
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 3351
       addi x29, x17, 4068
       li x23,7419
       bne x29, x23, _bad
   test_19 :
       li x17, 2181
       addi x29, x17, 1777
       li x23,3958
       bne x29, x23, _bad
   _exit :
       j _good
