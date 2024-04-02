
.section .text.init
.global _start

_start :
   test_0 :
       li x17, 1080
       li x1, 966
       sw x1, 0(x17)
       lw x11, 0(x17)
       bne x11, x1, _bad
   _exit :
       j _good
