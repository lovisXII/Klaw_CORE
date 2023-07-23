
.section .text
.global _start

_start :
   test_14 :
       li x17, 1491
       addi x29, x17, 81
       li x23,1572
       bne x29, x23, _bad
   test_15 :
       li x17, 3501
       addi x29, x17, 4012
       li x23,7513
       bne x29, x23, _bad
   _exit :
       j _good
