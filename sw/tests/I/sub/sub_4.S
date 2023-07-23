
.section .text
.global _start

_start :
   test_8 :
       li x17, 1038
       li x21, 3458
       sub x29, x17, x21
       li x23, -2420
       bne x29, x23, _bad
   test_9 :
       li x17, 2164
       li x8, 1601
       sub x29, x17, x8
       li x23, 563
       bne x29, x23, _bad
   _exit :
       j _good
