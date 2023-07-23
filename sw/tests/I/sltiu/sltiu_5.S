
.section .text
.global _start

_start :
   test_10 :
       li x17, 4041
       sltiu x29, x17, 451
       li x23,-1
       bne x29, x23, _bad
   test_11 :
       li x17, 2944
       sltiu x29, x17, 3678
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
