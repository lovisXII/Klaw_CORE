
.section .text
.global _start

_start :
   test_18 :
       li x17, 3209
       li x31, 2553
       sll x29, x17, x31
       li x23, 301989888
       bne x29, x23, _bad
   test_19 :
       li x17, 3932
       li x16, 1723
       sll x29, x17, x16
       li x23, -536870912
       bne x29, x23, _bad
   _exit :
       j _good
