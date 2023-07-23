
.section .text
.global _start

_start :
   test_8 :
       li x17, 124
       li x21, 706
       add x29, x17, x21
       li x23, 830
       bne x29, x23, _bad
   test_9 :
       li x17, 2132
       li x8, 2040
       add x29, x17, x8
       li x23, 4172
       bne x29, x23, _bad
   _exit :
       j _good
