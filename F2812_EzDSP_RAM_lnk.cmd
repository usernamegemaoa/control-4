/*
//###########################################################################
//
// FILE:    F2812_EzDSP_RAM_lnk.cmd
//
// TITLE:   Linker Command File For F2812 eZdsp examples that run out of RAM
//          This linker file assumes the user is booting up in Jump to H0 mode
//
//###########################################################################
//
//  Ver | dd mmm yyyy | Who  | Description of changes
// =====|=============|======|===============================================
//  1.00| 11 Sep 2003 | L.H. | Changes since previous version (v.58 Alpha)
//      |             |      | Added BEGIN section to the start of H0
//      |             |      | Removed .bss, .const and .sysmem
//      |             |      |    These are for a small memory model.  All examples
//      |             |      |    use the large model.
//      |             |      | Added .esysmem section
//      |             |      | Changed ramfuncs section to load and run from RAM
//      |             |      |    (previously this was type DSECT)
//      |             |      | Moved peripheral register files to DSP28_Headers_BIOS.cmd
//      |             |      |    and DSP28_Headers_nonBIOS.cmd
//      |             |      | Added CSM_RSVD memory section in FLASHA - this region
//      |             |      |    should be programmed with all 0x0000 when using the CSM
// -----|-------------|------|-----------------------------------------------
//###########################################################################
*/

/* ======================================================
// For Code Composer Studio V2.2 and later
// ---------------------------------------
// In addition to this memory linker command file, 
// add the header linker command file directly to the project. 
// The header linker command file is required to link the
// peripheral structures to the proper locations within 
// the memory map.
//
// The header linker files are found in <base>\DSP281x_Headers\cmd
//   
// For BIOS applications add:      DSP281x_Headers_nonBIOS.cmd
// For nonBIOS applications add:   DSP281x_Headers_nonBIOS.cmd    
========================================================= */

/* ======================================================
// For Code Composer Studio prior to V2.2
// --------------------------------------
// 1) Use one of the following -l statements to include the 
// header linker command file in the project. The header linker
// file is required to link the peripheral structures to the proper 
// locations within the memory map                                    */

/* Uncomment this line to include file only for non-BIOS applications */
/* -l DSP281x_Headers_nonBIOS.cmd */

/* Uncomment this line to include file only for BIOS applications */
/* -l DSP281x_Headers_BIOS.cmd */

/* 2) In your project add the path to <base>\DSP281x_headers\cmd to the
   library search path under project->build options, linker tab, 
   library search path (-i).
/*========================================================= */

-w

MEMORY
{
PAGE 0 :
   
   //BEGIN      : origin = 0x3F7FF6, length = 0x000002
   //PRAMH0     : origin = 0x3d8000, length = 0x010000 
   BEGIN      : origin = 0x3F8000, length = 0x000002              
   PRAMH0     : origin = 0x3f8002, length = 0x01000
   RESET       : origin = 0x3FFFC0, length = 0x000002     /* part of boot ROM (MP/MCn=0) or XINTF zone 7 (MP/MCn=1) */
   VECTORS     : origin = 0x3FFFC2, length = 0x00003E     /* part of boot ROM (MP/MCn=0) or XINTF zone 7 (MP/MCn=1) */
  
         
PAGE 1 : 

   /* For this example, H0 is split between PAGE 0 and PAGE 1 */

   RAMM1    : origin = 0x000400, length = 0x000400
   /*DRAMH0   : origin = 0x3f9002, length = 0x000800 */ 
   
   EXRAM    : origin = 0x100000, length = 0x10000  
     
}
 
 
SECTIONS
{
   /* Setup for "boot to H0" mode: 
      The codestart section (found in DSP28_CodeStartBranch.asm)
      re-directs execution to the start of user code.  
      Place this section at the start of H0  */
   
   codestart        : > BEGIN,       PAGE = 0
   ramfuncs         : > PRAMH0       PAGE = 0  
   .text            : > PRAMH0,      PAGE = 0
   .cinit           : > PRAMH0,      PAGE = 0
   .pinit           : > PRAMH0,      PAGE = 0
   .switch          : > PRAMH0,       PAGE = 0
   .reset           : > RESET,       PAGE = 0, TYPE = DSECT /* not used, */
   
   /*.stack           : > EXRAM,      PAGE = 1*/
   .stack           : > RAMM1,      PAGE = 1
   .ebss            : > EXRAM,      PAGE = 1
   .econst          : > EXRAM,      PAGE = 1      
   .esysmem         : > EXRAM,      PAGE = 1
   
   .sconst          : > EXRAM,      PAGE = 1  

     
}
