
.section .text
.global _start

_start :
   test_16 :
       li x17, 2918
       li x4, 3378
       add x29, x17, x4
       li x23, 6296
       bne x29, x23, _bad
   test_17 :
       li x17, 13
       li x23, 1975
       add x29, x17, x23
       li x23, 1988
       bne x29, x23, _bad
   _exit :
       j _good
