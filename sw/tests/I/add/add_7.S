
.section .text
.global _start

_start :
   test_14 :
       li x17, 563
       li x24, 1951
       add x29, x17, x24
       li x23, 2514
       bne x29, x23, _bad
   test_15 :
       li x17, 1225
       li x20, 1946
       add x29, x17, x20
       li x23, 3171
       bne x29, x23, _bad
   _exit :
       j _good
