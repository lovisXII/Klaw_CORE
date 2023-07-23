
.section .text
.global _start

_start :
   test_6 :
       li x17, 3436
       andi x29, x17, 2867
       li x23,2336
       bne x29, x23, _bad
   test_7 :
       li x17, 3037
       andi x29, x17, 706
       li x23,704
       bne x29, x23, _bad
   _exit :
       j _good
