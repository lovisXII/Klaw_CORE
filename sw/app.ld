OUTPUT_ARCH( "riscv" )
ENTRY( _start )
SECTIONS
{
  . = 0x80000000;
  .text.init    : { *(.text.init) }
  . = ALIGN(0x1000);
  .tohost       : { *(.tohost) }
  . = ALIGN(0x1000);
  .text         : { *(.text) }
  . = ALIGN(0x1000);
  .text         : { *(.reset) }
  . = ALIGN(0x1000);
  .text         : { *(.kernel) }
  . = ALIGN(0x1000);
  .text         : { *(.exit) }
  . = ALIGN(0x1000);
  .data         : { *(.data) }
  .data.string  : { *(.data.string)}
  .bss          : { *(.bss) }
  _end = .;
}
