
.section .text
.global _start

_start :
   test_4 :
       li x17, 2895
       li x26, 3890
       srl x29, x17, x26
       li x23, 0
       bne x29, x23, _bad
   test_5 :
       li x17, 3349
       li x28, 329
       srl x29, x17, x28
       li x23, 6
       bne x29, x23, _bad
   _exit :
       j _good
