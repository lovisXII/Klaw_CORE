
.section .text.init
.global _start

_start :
   test_10 :
       li x17, 671
       srai x29, x17, 2958
       li x23,-1
       bne x29, x23, _bad
   test_11 :
       li x17, 980
       srai x29, x17, 3736
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
