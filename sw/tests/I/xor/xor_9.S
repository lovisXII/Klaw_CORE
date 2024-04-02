
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 1851
       li x31, 2308
       xor x29, x17, x31
       li x23, 3647
       bne x29, x23, _bad
   test_19 :
       li x17, 1884
       li x16, 2515
       xor x29, x17, x16
       li x23, 3727
       bne x29, x23, _bad
   _exit :
       j _good
