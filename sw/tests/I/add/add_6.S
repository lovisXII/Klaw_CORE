
.section .text
.global _start

_start :
   test_12 :
       li x17, 3958
       li x17, 1370
       add x29, x17, x17
       li x23, 2740
       bne x29, x23, _bad
   test_13 :
       li x17, 2350
       li x30, 611
       add x29, x17, x30
       li x23, 2961
       bne x29, x23, _bad
   _exit :
       j _good
