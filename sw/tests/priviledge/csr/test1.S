.section .text
.global _start

_start :
   li x1, 0xFFFFFFFF
   csrw mepc, x1
   csrrci x0, mepc, 0x1
   csrr x4, mepc
   li x3, 0xFFFFFFFE
   beq x4, x3, _good
   j _bad