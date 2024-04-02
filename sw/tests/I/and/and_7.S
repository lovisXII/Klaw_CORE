
.section .text.init
.global _start

_start :
   test_14 :
       li x17, 3049
       li x24, 3042
       and x29, x17, x24
       li x23, 3040
       bne x29, x23, _bad
   test_15 :
       li x17, 3166
       li x20, 339
       and x29, x17, x20
       li x23, 82
       bne x29, x23, _bad
   _exit :
       j _good
