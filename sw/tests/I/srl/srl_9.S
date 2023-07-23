
.section .text
.global _start

_start :
   test_18 :
       li x17, 1868
       li x31, 3543
       srl x29, x17, x31
       li x23, 0
       bne x29, x23, _bad
   test_19 :
       li x17, 1581
       li x16, 667
       srl x29, x17, x16
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
