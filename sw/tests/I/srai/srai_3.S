
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 528
       srai x29, x17, 3979
       li x23,-1
       bne x29, x23, _bad
   test_7 :
       li x17, 2919
       srai x29, x17, 4047
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
