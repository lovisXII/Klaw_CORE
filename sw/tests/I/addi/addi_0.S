
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 2520
       addi x29, x17, 1845
       li x23,4365
       bne x29, x23, _bad
   test_1 :
       li x17, 1256
       addi x29, x17, 3284
       li x23,4540
       bne x29, x23, _bad
   _exit :
       j _good
