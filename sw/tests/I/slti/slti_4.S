
.section .text
.global _start

_start :
   test_8 :
       li x17, 1349
       slti x29, x17, 1593
       li x23,1
       bne x29, x23, _bad
   test_9 :
       li x17, 770
       slti x29, x17, 2264
       li x23,1
       bne x29, x23, _bad
   _exit :
       j _good
