
.section .text
.global _start

_start :
   test_4 :
       li x17, 3881
       li x26, 3277
       add x29, x17, x26
       li x23, 7158
       bne x29, x23, _bad
   test_5 :
       li x17, 2234
       li x28, 1963
       add x29, x17, x28
       li x23, 4197
       bne x29, x23, _bad
   _exit :
       j _good
