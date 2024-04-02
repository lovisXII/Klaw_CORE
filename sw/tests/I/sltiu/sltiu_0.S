
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 2253
       sltiu x29, x17, 3350
       li x23,-1
       bne x29, x23, _bad
   test_1 :
       li x17, 3432
       sltiu x29, x17, 698
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
