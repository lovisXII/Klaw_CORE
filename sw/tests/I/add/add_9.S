
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 2609
       li x31, 1112
       add x29, x17, x31
       li x23, 3721
       bne x29, x23, _bad
   test_19 :
       li x17, 163
       li x16, 2394
       add x29, x17, x16
       li x23, 2557
       bne x29, x23, _bad
   _exit :
       j _good
