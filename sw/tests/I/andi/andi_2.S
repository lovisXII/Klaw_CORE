
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 1889
       andi x29, x17, 1237
       li x23,1089
       bne x29, x23, _bad
   test_5 :
       li x17, 597
       andi x29, x17, 3793
       li x23,593
       bne x29, x23, _bad
   _exit :
       j _good
