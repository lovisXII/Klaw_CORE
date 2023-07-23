
.section .text
.global _start

_start :
   test_18 :
       li x17, 3051
       andi x29, x17, 1126
       li x23,98
       bne x29, x23, _bad
   test_19 :
       li x17, 1060
       andi x29, x17, 844
       li x23,4
       bne x29, x23, _bad
   _exit :
       j _good
