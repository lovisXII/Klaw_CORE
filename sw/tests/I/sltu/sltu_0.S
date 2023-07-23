
.section .text
.global _start

_start :
   test_0 :
       li x17, 315
       li x1, 3952
       sltu x29, x17, x1
       li x23, 1
       bne x29, x23, _bad
   test_1 :
       li x17, 3684
       li x3, 1572
       sltu x29, x17, x3
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
