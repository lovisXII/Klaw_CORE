
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 3092
       li x19, 2003
       or x29, x17, x19
       li x23, 4055
       bne x29, x23, _bad
   test_7 :
       li x17, 3545
       li x12, 2612
       or x29, x17, x12
       li x23, 4093
       bne x29, x23, _bad
   _exit :
       j _good
