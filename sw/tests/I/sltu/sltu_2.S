
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 170
       li x26, 3028
       sltu x29, x17, x26
       li x23, 1
       bne x29, x23, _bad
   test_5 :
       li x17, 2476
       li x28, 498
       sltu x29, x17, x28
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
