//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2008-2010 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2009-07-15 13:39:23 +0100 (Wed, 15 Jul 2009) $
//
//      Revision            : $Revision: 113433 $
//
//      Release Information : Cortex-M0-AT510-r0p0-03rel0
//-----------------------------------------------------------------------------

module cm0_acg #(parameter CBAW = 0,
                   parameter ACG  = 1)
                  (input  wire CLKIN,
                   input  wire ENABLE,
                   input  wire SE,
                   output wire CLKOUT );

   // ------------------------------------------------------------
   // NOTE: THIS MODULE IS NOT INTENDED FOR USE IN SYNTHESIS.
   //       IF ARCHITECTURAL CLOCK GATING IS REQUIRED, THEN IT IS
   //       STRONGLY RECOMMENDED THAT AN EQUIVALENT MODULE
   //       DIRECTLY INSTANTIATING YOUR TARGET LIBRARY'S ICG CELL
   //       IS USED IN PLACE OF THIS SIMULATION MODEL,
   //
   //       If architectural clock gating is not required,
   //       indicated by the ACG parameter being passed in as 0,
   //       CLKOUT must be assigned directly from CLKIN
   // ------------------------------------------------------------
   
   // ------------------------------------------------------------
   // Simulation model of clock gate cell
   // ------------------------------------------------------------   
   // Extra terms present to remove model if cfg_acg is 0

   reg  clk_en;
   wire cfg_acg    = (CBAW == 0) ? (ACG != 0) : 1'bZ;

   wire clk_en_nxt = ENABLE | ~cfg_acg;
   wire gated_clk  = CLKIN & clk_en;
   wire clk_out    = cfg_acg ? gated_clk : CLKIN;

   always @(CLKIN or clk_en_nxt)
     if(~CLKIN)
       clk_en <= clk_en_nxt;

   assign CLKOUT   = clk_out;

endmodule

// ---------------------------------------------------------------
// EOF
// ---------------------------------------------------------------
