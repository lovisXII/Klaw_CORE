
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 2610
       li x26, 3247
       sll x29, x17, x26
       li x23, 85524480
       bne x29, x23, _bad
   test_5 :
       li x17, 3388
       li x28, 3924
       sll x29, x17, x28
       li x23, -742391808
       bne x29, x23, _bad
   _exit :
       j _good
