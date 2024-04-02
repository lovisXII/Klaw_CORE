
.section .text.init
.global _start

_start :
   test_16 :
       li x17, 873
       xori x29, x17, 2812
       li x23,2453
       bne x29, x23, _bad
   test_17 :
       li x17, 3954
       xori x29, x17, 1409
       li x23,2803
       bne x29, x23, _bad
   _exit :
       j _good
