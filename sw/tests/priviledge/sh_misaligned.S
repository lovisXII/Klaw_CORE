.section .text
.global _start

_start:
    li x1, 0x700012311
    li x2, 0x15200
    sh x2, 0(x1)
    j _bad