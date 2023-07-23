
.section .text
.global _start

_start :
   test_6 :
       li x17, 763
       li x19, 2609
       and x29, x17, x19
       li x23, 561
       bne x29, x23, _bad
   test_7 :
       li x17, 1433
       li x12, 1680
       and x29, x17, x12
       li x23, 1168
       bne x29, x23, _bad
   _exit :
       j _good
