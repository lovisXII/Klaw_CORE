
.section .text
.global _start

_start :
   test_8 :
       li x17, 3516
       li x21, 3679
       xor x29, x17, x21
       li x23, 995
       bne x29, x23, _bad
   test_9 :
       li x17, 2894
       li x8, 631
       xor x29, x17, x8
       li x23, 2361
       bne x29, x23, _bad
   _exit :
       j _good
