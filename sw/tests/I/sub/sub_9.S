
.section .text
.global _start

_start :
   test_18 :
       li x17, 2538
       li x31, 2780
       sub x29, x17, x31
       li x23, -242
       bne x29, x23, _bad
   test_19 :
       li x17, 875
       li x16, 1942
       sub x29, x17, x16
       li x23, -1067
       bne x29, x23, _bad
   _exit :
       j _good
