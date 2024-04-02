
.section .text.init
.global _start

_start :
   test_14 :
       li x17, 1210
       li x24, 1947
       sltu x29, x17, x24
       li x23, 1
       bne x29, x23, _bad
   test_15 :
       li x17, 125
       li x20, 1525
       sltu x29, x17, x20
       li x23, 1
       bne x29, x23, _bad
   _exit :
       j _good
