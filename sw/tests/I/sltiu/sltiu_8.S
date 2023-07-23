
.section .text
.global _start

_start :
   test_16 :
       li x17, 3565
       sltiu x29, x17, 3282
       li x23,-1
       bne x29, x23, _bad
   test_17 :
       li x17, 2771
       sltiu x29, x17, 3225
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
