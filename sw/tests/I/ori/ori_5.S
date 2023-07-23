
.section .text
.global _start

_start :
   test_10 :
       li x17, 1904
       ori x29, x17, 2199
       li x23,4087
       bne x29, x23, _bad
   test_11 :
       li x17, 2270
       ori x29, x17, 3340
       li x23,3550
       bne x29, x23, _bad
   _exit :
       j _good
