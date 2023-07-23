
.section .text
.global _start

_start :
   test_16 :
       li x17, 1803
       li x4, 3809
       sltu x29, x17, x4
       li x23, 1
       bne x29, x23, _bad
   test_17 :
       li x17, 3098
       li x23, 284
       sltu x29, x17, x23
       li x23, 0
       bne x29, x23, _bad
   _exit :
       j _good
