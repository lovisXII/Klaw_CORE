
.section .text
.global _start

_start :
   test_8 :
       li x17, 2306
       li x21, 2074
       sll x29, x17, x21
       li x23, 134217728
       bne x29, x23, _bad
   test_9 :
       li x17, 2302
       li x8, 2883
       sll x29, x17, x8
       li x23, 18416
       bne x29, x23, _bad
   _exit :
       j _good
