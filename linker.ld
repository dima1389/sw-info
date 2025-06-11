SECTIONS
{
  .text : {
    *(.text*)
    *(.rodata*)
  } > FLASH

  .sw_info 0x0803F000 : ALIGN(4)
  {
    KEEP(*(.sw_info))
  } > FLASH
}
