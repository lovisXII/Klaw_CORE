
.section .text.init
.global _start

_start :
   test_14 :
       li x17, 270
       li x24, 3608
       srl x29, x17, x24
       li x23, 0
       bne x29, x23, _bad
   test_15 :
       li x17, 1960
       li x20, 68
       srl x29, x17, x20
       li x23, 122
       bne x29, x23, _bad
   _exit :
       j _good
