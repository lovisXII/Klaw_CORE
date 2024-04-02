.section .text.init
.global _start

_start :
   li x1, 0xFFFFFFFF
   csrw mepc, x1
   csrrci x0, mepc, 0x3
   csrrsi x0, mepc, 0x1
   csrr x4, mepc
   li x3, 0xFFFFFFFD
   beq x4, x3, _good
   j _bad