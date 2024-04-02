
.section .text.init
.global _start

_start :
   test_16 :
       li x17, 574
       li x4, 3841
       sub x29, x17, x4
       li x23, -3267
       bne x29, x23, _bad
   test_17 :
       li x17, 1662
       li x23, 2711
       sub x29, x17, x23
       li x23, -1049
       bne x29, x23, _bad
   _exit :
       j _good
