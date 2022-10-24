`include "atomicity.v"	
`include "region_validity.v"
`include "stack_protection.v"

`ifdef OMSP_NO_INCLUDE
`else
`include "openMSP430_defines.v"
`endif

module UCCA_region (
// INPUT//////////////////////////////////////////////////////////////////
    clk,
    pc,
    data_en,
    data_wr,
    data_addr,
    uccmin,
    uccmax,
    stack_pointer,

    irq,

// OUTPUT ////////////////////////////////////////////////////////////////    
    // For formal verification
    return_address,
    base_pointer,
    
    
    reset
    
);

input         clk;
input  [15:0] pc;
input         data_en;
input         data_wr;
input  [15:0] data_addr;
input  [15:0] uccmin;
input  [15:0] uccmax;
input  [15:0] stack_pointer;
input         irq;

output        reset;

// For formal verification
output [15:0]  return_address;
output [15:0]  base_pointer;



// MACROS ////////////////////////////////////////////////////////////////
//parameter CONF_BASE = 16'h0160;
//parameter CONF_END = 16'h016B;
//////////////////////////////////////////////////////////////////////////

parameter RESET_HANDLER = 16'h0000;

wire region_validity_reset;
region_validity #(
) region_validty_0 (
    .clk          (clk),
    .pc           (pc),
    .region_start (uccmin),
    .region_stop  (uccmax),

    .reset        (region_validity_reset)
);

// For formal verification
wire [15:0] return_address;

wire    atomicity_reset;
atomicity #(
) atomicity_0 (
    .clk            (clk),
    .pc             (pc),
    .region_start   (uccmin),
    .region_stop    (uccmax), 
    
     // For formal verification
    .return_address (return_address),
    
    .reset          (atomicity_reset)
    
);

// For formal verification
wire [15:0] base_pointer;

wire stack_protection_reset;
stack_protection #(
) stack_protection_0 (
    .clk           (clk),
    .data_addr     (data_addr),
    .data_wr       (data_wr),
    .pc            (pc),
    .region_start  (uccmin),
    .region_stop   (uccmax),
    .stack_pointer (stack_pointer),
  
     // For formal verification
    .base_pointer  (base_pointer),
    
    .reset         (stack_protection_reset)
    
);

// OUTPUT LOGIC //////////////////////////////////////////////////////////
assign reset = region_validity_reset | atomicity_reset | stack_protection_reset;

endmodule
