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
//      Checked In          : $Date: 2009-09-15 11:52:22 +0100 (Tue, 15 Sep 2009) $
//
//      Revision            : $Revision: 117812 $
//
//      Release Information : Cortex-M0-AT510-r0p0-03rel0
//-----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// CORTEX-M0 AMBA-3 AHB-LITE TO EMBEDDED SRAM INTERFACE
// ----------------------------------------------------------------------------
// This block implements an AHB to SRAM bridge interface with zero-wait states
// Zero-wait state achieved by buffering AHB writes
// Note: The bridge must either be not shut down or must be retained for
// correct functionality (as it performs lazy writes)
// ----------------------------------------------------------------------------

module cm0ik_ahb_sram_bridge
  #(parameter AWIDTH = 12)
   (// AHB INTERFACE --------------------------------------------
    input  wire              HCLK,
    input  wire              HRESETn,
    input  wire [31:0]       HADDR,
    input  wire [ 2:0]       HBURST,
    input  wire              HMASTLOCK,
    input  wire [ 3:0]       HPROT,
    input  wire [ 2:0]       HSIZE,
    input  wire [ 1:0]       HTRANS,
    input  wire [31:0]       HWDATA,
    input  wire              HWRITE,
    input  wire              HSEL,
    input  wire              HREADY,
    output wire [31:0]       HRDATA,
    output wire              HREADYOUT,
    output wire              HRESP,

    // EMBEDDED SRAM INTERFACE ----------------------------------
    input  wire [31:0]       RAMRD,           // Read Data Bus
    output wire [AWIDTH-3:0] RAMAD,           // Address Bus
    output wire [31:0]       RAMWD,           // Write Data Bus
    output wire              RAMCS,           // Chip Select
    output wire [ 3:0]       RAMWE            // Write Enable
    );

   // ----------------------------------------------------------
   // Internal state
   // ----------------------------------------------------------

   reg [AWIDTH-3:0]          buf_addr;        // Write address buffer  
   reg  [ 3:0]               buf_we;          // Write enable buffer  
   reg                       buf_hit;         // High when AHB read address 
                                              // matches buffered address
   reg  [31:0]               buf_data;        // AHB write bus buffered 
   reg                       buf_valid;       // Buffer write data valid 
   reg                       buf_data_en;     // Data buffer write enable
   wire [31:0]               ram_wd;          // RAM write data bus      

   // ----------------------------------------------------------
   // Read/write control logic
   // ----------------------------------------------------------

   wire        ahb_access   = HTRANS[1] & HSEL & HREADY;
   wire        ahb_write    = ahb_access &  HWRITE;
   wire        ahb_read     = ahb_access & ~HWRITE;
   
   //Buffer active if any of the write enables are set
   wire        buf_active   = |buf_we;
   //RAM write happens when new AHB write seen
   wire        ram_write    = ahb_write & buf_active;
   
   //RAM chip select high if AHB Read or RAM write
   wire        ram_cs       = ahb_read | ram_write;
   //RAM WE is the buffered WE
   wire [ 3:0] ram_we       = {4{ram_write}} & buf_we[3:0];
   //RAM address is the buffered address for RAM write otherwise HADDR
   wire [AWIDTH-3:0] ram_ad = ram_write ? buf_addr : HADDR[AWIDTH-1:2];

   // ----------------------------------------------------------
   // Byte lane decoder and next state logic
   // ----------------------------------------------------------

   wire       tx_byte    = ~HSIZE[1] & ~HSIZE[0];
   wire       tx_half    = ~HSIZE[1] &  HSIZE[0];
   wire       tx_word    =  HSIZE[1];

   wire       byte_at_00 = tx_byte & ~HADDR[1] & ~HADDR[0];
   wire       byte_at_01 = tx_byte & ~HADDR[1] &  HADDR[0];
   wire       byte_at_10 = tx_byte &  HADDR[1] & ~HADDR[0];
   wire       byte_at_11 = tx_byte &  HADDR[1] &  HADDR[0];

   wire       half_at_00 = tx_half & ~HADDR[1];
   wire       half_at_10 = tx_half &  HADDR[1];

   wire       word_at_00 = tx_word;

   wire       byte_sel_0 = word_at_00 | half_at_00 | byte_at_00;
   wire       byte_sel_1 = word_at_00 | half_at_00 | byte_at_01;
   wire       byte_sel_2 = word_at_00 | half_at_10 | byte_at_10;
   wire       byte_sel_3 = word_at_00 | half_at_10 | byte_at_11;

   wire [3:0] buf_we_nxt = { byte_sel_3 & ahb_write,
                             byte_sel_2 & ahb_write,
                             byte_sel_1 & ahb_write,
                             byte_sel_0 & ahb_write };

   //Latch buf_we on every new AHB write
   wire       buf_we_en  = ahb_write;

   // ----------------------------------------------------------
   // Buf_hit detection logic
   // ----------------------------------------------------------

   wire       buf_hit_nxt = (HADDR[AWIDTH-1:2] == buf_addr[AWIDTH-3:0]);

   // ----------------------------------------------------------
   // Read data merge : This is for the case when there is a AHB 
   // write followed by AHB read to the same address. In this case
   // the data is merged from the buffer as the RAM write to that
   // address hasn't happened yet
   // ----------------------------------------------------------

   wire [ 3:0] merge       = {4{buf_hit}} & buf_we;

   wire [31:0] ahb_rdata   =
              { merge[3] ? buf_data[31:24] : RAMRD[31:24],
                merge[2] ? buf_data[23:16] : RAMRD[23:16],
                merge[1] ? buf_data[15: 8] : RAMRD[15: 8],
                merge[0] ? buf_data[ 7: 0] : RAMRD[ 7: 0] };

   // ----------------------------------------------------------
   // Synchronous state update
   // ----------------------------------------------------------
   
   always @(posedge HCLK or negedge HRESETn)
     if(~HRESETn)
       buf_we <= 4'b0000;
     else if(buf_we_en)
       buf_we <= buf_we_nxt;

   always @(posedge HCLK)
     buf_data_en <= ahb_write;

   always @(posedge HCLK)
     if(ahb_read)
       buf_hit <= buf_hit_nxt;

   always @(posedge HCLK)
     if(ahb_write)
       buf_addr <= HADDR[AWIDTH-1:2];

   always @(posedge HCLK)
     if(buf_we[3] & buf_data_en)
       buf_data[31:24] <= HWDATA[31:24];

   always @(posedge HCLK)
     if(buf_we[2] & buf_data_en)
       buf_data[23:16] <= HWDATA[23:16];
 
   always @(posedge HCLK)
     if(buf_we[1] & buf_data_en)
       buf_data[15: 8] <= HWDATA[15: 8];
      
   always @(posedge HCLK)
     if(buf_we[0] & buf_data_en)
       buf_data[ 7: 0] <= HWDATA[ 7: 0];

   always @(posedge HCLK)
     if(HREADY)
       buf_valid <= ~buf_we_en;

   //if there is an AHB write and valid data in the buffer, RAM write data
   //comes from the buffer otherwise from the HWDATA
   assign ram_wd = (buf_we_en & buf_valid) ? buf_data : HWDATA[31:0];

   // ----------------------------------------------------------
   // Assign outputs
   // ----------------------------------------------------------

   assign HRDATA    = ahb_rdata;
   assign HREADYOUT = 1'b1;
   assign HRESP     = 1'b0;

   assign RAMWD     = ram_wd;
   assign RAMCS     = ram_cs;
   assign RAMWE     = ram_we;
   assign RAMAD     = ram_ad;


endmodule

// ----------------------------------------------------------------------------
// EOF
// ----------------------------------------------------------------------------
