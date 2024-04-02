
.section .text.init
.global _start

_start :
   test_10 :
       li x17, 1418
       li x22, 2601
       srl x29, x17, x22
       li x23, 2
       bne x29, x23, _bad
   test_11 :
       li x17, 1620
       li x6, 840
       srl x29, x17, x6
       li x23, 6
       bne x29, x23, _bad
   _exit :
       j _good
