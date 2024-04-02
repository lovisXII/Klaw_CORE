
.section .text.init
.global _start

_start :
   test_18 :
       li x17, 3094
       ori x29, x17, 2242
       li x23,3286
       bne x29, x23, _bad
   test_19 :
       li x17, 1185
       ori x29, x17, 3236
       li x23,3237
       bne x29, x23, _bad
   _exit :
       j _good
