
.section .text.init
.global _start

_start :
   test_14 :
       li x17, 426
       li x24, 2330
       xor x29, x17, x24
       li x23, 2224
       bne x29, x23, _bad
   test_15 :
       li x17, 2645
       li x20, 2722
       xor x29, x17, x20
       li x23, 247
       bne x29, x23, _bad
   _exit :
       j _good
