
.section .text.init
.global _start

_start :
   test_10 :
       li x17, 795
       li x22, 2536
       add x29, x17, x22
       li x23, 3331
       bne x29, x23, _bad
   test_11 :
       li x17, 3559
       li x6, 909
       add x29, x17, x6
       li x23, 4468
       bne x29, x23, _bad
   _exit :
       j _good
