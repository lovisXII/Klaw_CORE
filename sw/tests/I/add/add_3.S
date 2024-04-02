
.section .text.init
.global _start

_start :
   test_6 :
       li x17, 498
       li x19, 3835
       add x29, x17, x19
       li x23, 4333
       bne x29, x23, _bad
   test_7 :
       li x17, 2531
       li x12, 326
       add x29, x17, x12
       li x23, 2857
       bne x29, x23, _bad
   _exit :
       j _good
