
.section .text
.global _start

_start :
   test_18 :
       li x17, 3616
       li x31, 2234
       sra x29, x17, x31
       li x23, 0
       bne x29, x23, _bad
   test_19 :
       li x17, 2950
       li x16, 3267
       sra x29, x17, x16
       li x23, 368
       bne x29, x23, _bad
   _exit :
       j _good
