
.section .text
.global _start

_start :
   test_16 :
       li x17, 3756
       li x4, 2651
       srl x29, x17, x4
       li x23, 0
       bne x29, x23, _bad
   test_17 :
       li x17, 2547
       li x23, 2958
       srl x29, x17, x23
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
