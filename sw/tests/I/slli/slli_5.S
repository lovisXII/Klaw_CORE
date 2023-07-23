
.section .text
.global _start

_start :
   test_10 :
       li x17, 1716
       slli x29, x17, 2921
       li x23,878592
       bne x29, x23, _bad
   test_11 :
       li x17, 1839
       slli x29, x17, 3642
       li x23,-1140850688
       bne x29, x23, _bad
   _exit :
       j _good
