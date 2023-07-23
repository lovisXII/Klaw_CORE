
.section .text
.global _start

_start :
   test_14 :
       li x17, 3492
       andi x29, x17, 2637
       li x23,2052
       bne x29, x23, _bad
   test_15 :
       li x17, 2689
       andi x29, x17, 3208
       li x23,2176
       bne x29, x23, _bad
   _exit :
       j _good
