
.section .text.init
.global _start

_start :
   test_14 :
       li x17, 1531
       li x24, 3250
       sra x29, x17, x24
       li x23, 0
       bne x29, x23, _bad
   test_15 :
       li x17, 2055
       li x20, 772
       sra x29, x17, x20
       li x23, 128
       bne x29, x23, _bad
   _exit :
       j _good
