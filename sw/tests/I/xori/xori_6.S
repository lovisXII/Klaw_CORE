
.section .text
.global _start

_start :
   test_12 :
       li x17, 277
       xori x29, x17, 258
       li x23,23
       bne x29, x23, _bad
   test_13 :
       li x17, 1415
       xori x29, x17, 2657
       li x23,4070
       bne x29, x23, _bad
   _exit :
       j _good
