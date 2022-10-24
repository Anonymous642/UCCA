module stack_protection (
// INPUT /////////////////////////////////////////////////////////////////
    clk,
    data_addr,
    data_wr,
    pc,
    region_start,
    region_stop,
    stack_pointer,

// OUTPUT ////////////////////////////////////////////////////////////////
    //base_pointer,  // For formal verification
    
    reset
);

input          clk;
input  [15:0]  data_addr;
input          data_wr;
input  [15:0]  pc;
input  [15:0]  region_start;
input  [15:0]  region_stop;
input  [15:0]  stack_pointer;

output         reset;

// For formal verification
//output [15:0]  base_pointer;


// FSM States ////////////////////////////////////////////////////////////
parameter notUCC =  2'b00;
parameter inUCC  =  2'b01;
parameter RST    =  2'b10;
//////////////////////////////////////////////////////////////////////////
parameter RESET_HANDLER = 16'h0000;

wire is_outside_UCC = pc < region_start || pc > region_stop;
wire pc_in_UCC = pc >= region_start && pc <= region_stop;
wire is_first_UCC = pc == region_start;

reg [1:0]  state;
reg [15:0] ebp;
reg        invalid_write;
wire valid_stack_write = (data_addr < ebp); 

initial
begin
    state = RST;
    ebp = 16'h0000;
    invalid_write = 1'b1;
end

always @(posedge clk)
begin
    case (state)
        notUCC:
            begin
                ebp <= stack_pointer;
                if (pc_in_UCC)
                begin
                    if (data_wr && !valid_stack_write)
                        state <= RST;
                    else
                        state <= inUCC;
                end
                else
                    state <= state;
            end
        inUCC:
            if (is_outside_UCC)
                begin
                    state <= notUCC;
                    ebp <= stack_pointer;
                end
            else if (data_wr && !valid_stack_write)
                state <= RST;
            else
                state <= state;
        RST:
            if (pc == RESET_HANDLER)
                begin
                    state <= notUCC;
                    ebp <= stack_pointer;
                end
            else
                state <= state;
                
    endcase
end

// OUTPUT LOGIC //////////////////////////////////////////////////////////
always @(posedge clk)
begin
    if ( (state == notUCC && pc_in_UCC && data_wr && !valid_stack_write) ||
         (state == inUCC && !is_outside_UCC && data_wr && !valid_stack_write) || 
         (state == RST && pc != RESET_HANDLER)
       )
           invalid_write <= 1'b1;
    else
           invalid_write <= 1'b0;
end

assign reset = invalid_write;

// For formal verification 
//assign base_pointer = ebp;

endmodule
