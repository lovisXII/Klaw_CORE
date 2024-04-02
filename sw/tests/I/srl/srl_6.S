
.section .text.init
.global _start

_start :
   test_12 :
       li x17, 1690
       li x17, 2058
       srl x29, x17, x17
       li x23, 2
       bne x29, x23, _bad
   test_13 :
       li x17, 1724
       li x30, 3541
       srl x29, x17, x30
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
