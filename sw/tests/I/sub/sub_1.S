
.section .text
.global _start

_start :
   test_2 :
       li x17, 2136
       li x2, 2793
       sub x29, x17, x2
       li x23, -657
       bne x29, x23, _bad
   test_3 :
       li x17, 1118
       li x29, 2260
       sub x29, x17, x29
       li x23, -1142
       bne x29, x23, _bad
   _exit :
       j _good
