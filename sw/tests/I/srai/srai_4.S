
.section .text
.global _start

_start :
   test_8 :
       li x17, 3225
       srai x29, x17, 1616
       li x23,-1
       bne x29, x23, _bad
   test_9 :
       li x17, 3675
       srai x29, x17, 3607
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
