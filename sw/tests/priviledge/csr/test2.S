.section .text.init
.global _start

_start :
   li x1, 0xffffffff
   li x2, 0xffffffff
   li x3, 0xffffffff
   li x4, 0xffffffff
   csrrw x0, mepc, x1
   csrrw x0, mtval, x2
   csrrw x0, mcause, x3
   csrrw x0, mscratch, x4
   csrrs x0, mscratch, x0
   li x1, 0xff
   csrrc x1, mscratch, x1 # mscratch = 0xffffff00
   li x1, 0xFFFFFFFE
   csrrc x0, mepc, x1     # mepc = 0x1
   li t0, 0x1
   li t1, 0xffffff00
   csrrw t2, mscratch, x0
   csrrw t3, mepc, x0
   bne t0, t3, _bad
   bne t1, t2, _bad
   j _good