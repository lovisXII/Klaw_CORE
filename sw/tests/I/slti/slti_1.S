
.section .text
.global _start

_start :
   test_2 :
       li x17, 309
       slti x29, x17, 961
       li x23,1
       bne x29, x23, _bad
   test_3 :
       li x17, 199
       slti x29, x17, 740
       li x23,1
       bne x29, x23, _bad
   _exit :
       j _good
