
module  CR_peripheral (

// OUTPUTs
    per_dout,                         // Peripheral data output
    ucc1min,                          
    ucc1max,                          
    ucc2min,                         
    ucc2max,
   
    // Extra UCC definitions
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
    ucc8max,
*/


// OUTPUTs
//=========
output      [15:0] per_dout;        // Peripheral data output
output      [15:0] ucc1min;                          
output      [15:0] ucc1max;                          
output      [15:0] ucc2min;                          
output      [15:0] ucc2max;

/* 
output      [15:0] ucc3min;                          
output      [15:0] ucc3max; 
output      [15:0] ucc4min;                          
output      [15:0] ucc4max; 
output      [15:0] ucc5min;                          
output      [15:0] ucc5max; 
output      [15:0] ucc6min;                          
output      [15:0] ucc6max; 
output      [15:0] ucc7min;                          
output      [15:0] ucc7max; 
output      [15:0] ucc8min;                          
output      [15:0] ucc8max; 
*/
                     


reg    [15:0] crmem [0:15];
reg   [15:0] ucc1_min;
reg   [15:0] ucc1_max;
reg   [15:0] ucc2_min;
reg   [15:0] ucc2_max;

/*
reg   [15:0] ucc3_min;
reg   [15:0] ucc3_max;
reg   [15:0] ucc4_min;
reg   [15:0] ucc4_max;
reg   [15:0] ucc5_min;
reg   [15:0] ucc5_max;
reg   [15:0] ucc6_min;
reg   [15:0] ucc6_max;
reg   [15:0] ucc7_min;
reg   [15:0] ucc7_max;
reg   [15:0] ucc8_min;
reg   [15:0] ucc8_max;
*/

initial begin
    $readmemh("cr.mem", crmem);
    ucc1_min <= crmem[0];
    ucc1_max <= crmem[1];
    ucc2_min <= crmem[2];
    ucc2_max <= crmem[3];
    
/*
    ucc3_min <= crmem[4];
    ucc3_max <= crmem[5];
    ucc4_min <= crmem[6];
    ucc4_max <= crmem[7];
    ucc5_min <= crmem[8];
    ucc5_max <= crmem[9];
    ucc6_min <= crmem[10];
    ucc6_max <= crmem[11];
    ucc7_min <= crmem[12];
    ucc7_max <= crmem[13];
    ucc8_min <= crmem[14];
    ucc8_max <= crmem[15];
*/
end
                         
wire [15:0] ucc1min = ucc1_min;
wire [15:0] ucc1max = ucc1_max;
wire [15:0] ucc2min = ucc2_min;
wire [15:0] ucc2max = ucc2_max;

/*
wire [15:0] ucc3min = ucc3_min;
wire [15:0] ucc3max = ucc3_max;
wire [15:0] ucc4min = ucc4_min;
wire [15:0] ucc4max = ucc4_max;
wire [15:0] ucc5min = ucc5_min;
wire [15:0] ucc5max = ucc5_max;
wire [15:0] ucc6min = ucc6_min;
wire [15:0] ucc6max = ucc6_max;
wire [15:0] ucc7min = ucc7_min;
wire [15:0] ucc7max = ucc7_max;
wire [15:0] ucc8min = ucc8_min;
wire [15:0] ucc8max = ucc8_max;
*/

endmodule
