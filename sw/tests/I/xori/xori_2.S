
.section .text
.global _start

_start :
   test_4 :
       li x17, 3545
       xori x29, x17, 4045
       li x23,532
       bne x29, x23, _bad
   test_5 :
       li x17, 3653
       xori x29, x17, 3491
       li x23,998
       bne x29, x23, _bad
   _exit :
       j _good
