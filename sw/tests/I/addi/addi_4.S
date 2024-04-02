
.section .text.init
.global _start

_start :
   test_8 :
       li x17, 1855
       addi x29, x17, 1122
       li x23,2977
       bne x29, x23, _bad
   test_9 :
       li x17, 1664
       addi x29, x17, 809
       li x23,2473
       bne x29, x23, _bad
   _exit :
       j _good
