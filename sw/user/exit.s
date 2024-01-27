.section .tohost, "aw", @progbits

.globl tohost
.align 4
tohost: .dword 0

.globl fromhost
.align 4
fromhost: .dword 0

.space 16

write_tohost:
    li t1, 1
    la t5, .tohost
    sw t1,0(t5)
    j write_tohost

.space 16
.globl _good
.globl _bad
.globl _exception_occur
.space 16

_bad :
    j write_tohost
_good :
    j write_tohost
_exception_occur :
    j write_tohost

.space 16
