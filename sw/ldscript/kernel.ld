OUTPUT_ARCH( "riscv" )

SECTIONS
{
   . = seg_reset;
   .reset : { *(.reset) }
   . = ALIGN(0x1000);
   .kernel : { *(.kernel) }
   . = ALIGN(0x1000);
   .exit   : { *(.exit) }
   _kernel_end = .;
}

