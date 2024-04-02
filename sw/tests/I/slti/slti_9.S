
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 620
       slti x29, x17, 2633
       li x23,1
       bne x29, x23, _bad
   test_19 :
       li x17, 686
       slti x29, x17, 3216
       li x23,1
       bne x29, x23, _bad
   _exit :
       j _good
