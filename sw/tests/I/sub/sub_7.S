
.section .text
.global _start

_start :
   test_14 :
       li x17, 577
       li x24, 2273
       sub x29, x17, x24
       li x23, -1696
       bne x29, x23, _bad
   test_15 :
       li x17, 3580
       li x20, 871
       sub x29, x17, x20
       li x23, 2709
       bne x29, x23, _bad
   _exit :
       j _good
