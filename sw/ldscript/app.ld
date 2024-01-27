OUTPUT_ARCH( "riscv" )

SECTIONS
{
   . = seg_user;
   .text : { *(.text) }
   . = ALIGN(0x1000);
   .tohost : { *(.tohost) }
   . = ALIGN(0x1000);
   .data : { *(.data) }
   .data.string : { *(.data.string)}
   .bss : { *(.bss) }
   _app_end = .;
}

