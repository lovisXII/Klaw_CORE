
.section .text
.global _start

_start :
   test_8 :
       li x17, 431
       slli x29, x17, 1634
       li x23,1724
       bne x29, x23, _bad
   test_9 :
       li x17, 3516
       slli x29, x17, 1923
       li x23,28128
       bne x29, x23, _bad
   _exit :
       j _good
