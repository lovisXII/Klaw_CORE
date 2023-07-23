
.section .text
.global _start

_start :
   test_8 :
       li x17, 2568
       li x21, 3184
       srl x29, x17, x21
       li x23, 0
       bne x29, x23, _bad
   test_9 :
       li x17, 4052
       li x8, 2994
       srl x29, x17, x8
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
