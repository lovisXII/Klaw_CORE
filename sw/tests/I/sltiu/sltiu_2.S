
.section .text.init
.global _start

_start :
   test_4 :
       li x17, 692
       sltiu x29, x17, 3496
       li x23,-1
       bne x29, x23, _bad
   test_5 :
       li x17, 3274
       sltiu x29, x17, 2201
       li x23,-1
       bne x29, x23, _bad
   _exit :
       j _good
