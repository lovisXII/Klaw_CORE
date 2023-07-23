
.section .text
.global _start

_start :
   test_14 :
       li x17, 1660
       xori x29, x17, 1555
       li x23,111
       bne x29, x23, _bad
   test_15 :
       li x17, 1634
       xori x29, x17, 2462
       li x23,4092
       bne x29, x23, _bad
   _exit :
       j _good
