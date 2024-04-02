
.section .text.init
.global _start

_start :
   test_16 :
       li x17, 1926
       addi x29, x17, 661
       li x23,2587
       bne x29, x23, _bad
   test_17 :
       li x17, 3200
       addi x29, x17, 2284
       li x23,5484
       bne x29, x23, _bad
   _exit :
       j _good
