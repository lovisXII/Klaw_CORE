.section .text.init
.global _start

_start :
    li x1,0x7FFFFF00
    jalr x0,0(x1)
