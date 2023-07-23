
.section .text
.global _start

_start :
   test_6 :
       li x17, 2540
       li x19, 2840
       sll x29, x17, x19
       li x23, -335544320
       bne x29, x23, _bad
   test_7 :
       li x17, 4059
       li x12, 1116
       sll x29, x17, x12
       li x23, -1342177280
       bne x29, x23, _bad
   _exit :
       j _good
