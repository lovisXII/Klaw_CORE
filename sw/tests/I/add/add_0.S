
.section .text.init
.globl _start

_start :
   test_0 :
       li x17, 1383
       li x1, 966
       add x29, x17, x1
       li x23, 2349
       bne x29, x23, _bad
   test_1 :
       li x17, 2153
       li x3, 2163
       add x29, x17, x3
       li x23, 4316
       bne x29, x23, _bad
   _exit :
       j _good
