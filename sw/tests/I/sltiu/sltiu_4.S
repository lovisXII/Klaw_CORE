
.section .text
.global _start

_start :
   test_8 :
       li x17, 2507
       sltiu x29, x17, 2056
       li x23,-1
       bne x29, x23, _bad
   test_9 :
       li x17, 2767
       sltiu x29, x17, 609
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
