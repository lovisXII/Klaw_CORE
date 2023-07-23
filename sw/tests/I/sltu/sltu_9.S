
.section .text
.global _start

_start :
   test_18 :
       li x17, 3967
       li x31, 3363
       sltu x29, x17, x31
       li x23, 0
       bne x29, x23, _bad
   test_19 :
       li x17, 2808
       li x16, 41
       sltu x29, x17, x16
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
