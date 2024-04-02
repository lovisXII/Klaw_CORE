
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 3583
       slli x29, x17, 943
       li x23,117407744
       bne x29, x23, _bad
   test_13 :
       li x17, 1831
       slli x29, x17, 2838
       li x23,-910163968
       bne x29, x23, _bad
   _exit :
       j _good
