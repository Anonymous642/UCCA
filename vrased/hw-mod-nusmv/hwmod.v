`include "CR_integrity.v"
`include "UCCA_region.v"		

`ifdef OMSP_NO_INCLUDE
`else
`include "openMSP430_defines.v"
`endif

module hwmod (
    clk,
    pc,
    data_en,
    data_wr,
    data_addr,
    ucc1min,
    ucc1max,
    ucc2min,
    ucc2max,
    
    /*
    ucc3min,
    ucc3max,
    ucc4min,
    ucc4max,
    ucc5min,
    ucc5max,
    ucc6min,
    ucc6max,
    ucc7min,
    ucc7max,
    ucc8min,
    ucc8max
    */
    
    stack_pointer,
    
    irq,
    
    // For formal verification
    return_address,
    base_pointer,
    
    
    
    reset
);

input           clk;
input   [15:0]  pc;
input           data_en;
input           data_wr;
input   [15:0]  data_addr;
input         [15:0] ucc1min;
input         [15:0] ucc1max;
input         [15:0] ucc2min;
input         [15:0] ucc2max;

/*
input         [15:0] ucc3min;
input         [15:0] ucc3max;
input         [15:0] ucc4min;
input         [15:0] ucc4max;
input         [15:0] ucc5min;
input         [15:0] ucc5max;
input         [15:0] ucc6min;
input         [15:0] ucc6max;
input         [15:0] ucc7min;
input         [15:0] ucc7max;
input         [15:0] ucc8min;
input         [15:0] ucc8max;
*/

input   [15:0]  stack_pointer;


input           irq;
output          reset;

// For formal verification
output  [15:0]  return_address;
output  [15:0]  base_pointer;


// MACROS ///////////////////////////////////////////
parameter META_min = 16'h0140;
parameter META_max = 16'h0140 + 16'h002A;

parameter RESET_HANDLER = 16'h0000;

// For formal verification
parameter Start = 16'he080;
parameter Stop = 16'he081;
wire [15:0] return_address;
wire [15:0] base_pointer;


wire cr_integrity_reset;
CR_integrity #(
) CR_integrity_0 (
    .clk       (clk),
    .data_addr (data_addr),
    .data_wr   (data_wr),
    .pc        (pc),

    .reset     (cr_integrity_reset)
);

wire region1_reset;
UCCA_region #(
) UCCA__region0 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    //.uccmin         (ucc1min),
    //.uccmax         (ucc1max),
    
    // For formal verification
    .uccmin         (Start),     
    .uccmax         (Stop),  
    
    .stack_pointer  (stack_pointer),

     // For formal verification
    .return_address (return_address),
    .base_pointer   (base_pointer),
    

    .irq            (irq),
    
    .reset          (region1_reset)
    
);

/*
wire region2_reset;
UCCA_region #(
) UCCA_region1 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .uccmin         (ucc2min),
    .uccmax         (ucc2max),
    .stack_pointer  (stack_pointer),

    .irq            (irq),
    
    .reset          (region2_reset)
);


wire region3_reset;
UCCA_region #(
) UCCA_region2 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .uccmin         (ucc3min),
    .uccmax         (ucc3max),
    .stack_pointer  (stack_pointer),

    .irq        (irq),
    
    .reset      (region3_reset)
);


wire region4_reset;
UCCA_region #(
) UCCA_region3 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .uccmin         (ucc4min),
    .uccmax         (ucc4max),
    .stack_pointer  (stack_pointer),

    .irq        (irq),
    
    .reset      (region4_reset)
);


wire region5_reset;
UCCA_region #(
) UCCA_region4 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .uccmin         (ucc5min),
    .uccmax         (ucc5max),
    .stack_pointer  (stack_pointer),

    .irq        (irq),
    
    .reset      (region5_reset)
);


wire region6_reset;
UCCA_region #(
) UCCA_region5 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .uccmin         (ucc6min),
    .uccmax         (ucc6max),
    .stack_pointer  (stack_pointer),

    .irq        (irq),
    
    .reset      (region6_reset)
);


wire region7_reset;
UCCA_region #(
) UCCA_region6 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .uccmin         (ucc7min),
    .uccmax         (ucc7max),
    .stack_pointer  (stack_pointer),

    .irq        (irq),
    
    .reset      (region7_reset)
);


wire region8_reset;
UCCA_region #(
) UCCA_region7 (
    .clk            (clk),
    .pc             (pc),
    .data_en        (data_en),
    .data_wr        (data_wr),
    .data_addr      (data_addr),
    .uccmin         (ucc8min),
    .uccmax         (ucc8max),
    .stack_pointer  (stack_pointer),

    .irq        (irq),
    
    .reset      (region8_reset)
);
*/

assign reset = cr_integrity_reset | region1_reset;// | region2_reset; // | region3_reset | region4_reset | region5_reset | region6_reset | region7_reset | region8_reset;

endmodule
