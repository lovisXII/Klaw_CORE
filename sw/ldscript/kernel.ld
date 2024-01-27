OUTPUT_ARCH( "riscv" )

SECTIONS
{
   . = seg_reset: {
      *(.reset)
      *(.kernel)
      *(.exit)
   }
   _kernel_end = .;
}

