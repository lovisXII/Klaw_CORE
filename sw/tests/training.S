.section .text
.global _start

_start:

li x1, 15
li x2, 150
add x3, x1, x2


li x4, 165
bne x4, x3, _bad
j _good