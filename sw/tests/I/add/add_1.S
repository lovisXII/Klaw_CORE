
.section .text
.global _start

_start :
   test_2 :
       li x17, 3153
       li x2, 3327
       add x29, x17, x2
       li x23, 6480
       bne x29, x23, _bad
   test_3 :
       li x17, 1098
       li x29, 2284
       add x29, x17, x29
       li x23, 3382
       bne x29, x23, _bad
   _exit :
       j _good
