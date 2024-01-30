seg_reset   = 0xBFC00000;
seg_user    = 0x80000000;

SECTIONS
{
   . = seg_reset;
   .reset : { *(.reset) }
   . = ALIGN(0x1000);
   .kernel : { *(.kernel) }
   . = ALIGN(0x1000);
   .exit   : { *(.exit) }

   . = seg_user;
   .text         : { *(.text) }
   . = ALIGN(0x1000);
   .tohost       : { *(.tohost) }
   . = ALIGN(0x1000);
   .data         : { *(.data) }
   .data.string  : { *(.data.string)}
   .bss          : { *(.bss) }
   _end = .;

}
