
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 2813
       li x19, 1410
       srl x29, x17, x19
       li x23, 703
       bne x29, x23, _bad
   test_7 :
       li x17, 3662
       li x12, 1449
       srl x29, x17, x12
       li x23, 7
       bne x29, x23, _bad
   _exit :
       j _good
