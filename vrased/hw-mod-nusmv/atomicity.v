
module  atomicity (
// INPUT /////////////////////////////////////////////////////////////////
    clk,    
    pc,     
    region_start,
    region_stop, 

// OUTPUT ////////////////////////////////////////////////////////////////
    // For formal verification
    return_address,
    
    
    reset
);

input         clk;
input  [15:0] pc;
input  [15:0] region_start;
input  [15:0] region_stop;

output        reset;

// For formal verification
output [15:0] return_address;

// FSM States ////////////////////////////////////////////////////////////
parameter notUCC  = 3'b000;
parameter fstUCC = 3'b001;
parameter lastUCC = 3'b011;
parameter midUCC = 3'b010;
parameter RST = 3'b100;
//////////////////////////////////////////////////////////////////////////
parameter       RESET_HANDLER = 16'h0000;

reg [2:0]  state;
reg [15:0] return_addr;
reg        atomicity_reset;

initial
begin
        state = RST;
        atomicity_reset = 1'b1;
        return_addr = 16'h0000;
end

wire is_mid_UCC = pc > region_start && pc < region_stop;
wire is_first_UCC = pc == region_start;
wire is_last_UCC = pc == region_stop;
wire is_in_UCC = is_mid_UCC | is_first_UCC | is_last_UCC;
wire is_outside_UCC = pc < region_start | pc > region_stop;
wire valid_return = pc == return_addr;

always @(posedge clk)
begin
    case (state)
        notUCC:
            if (is_outside_UCC)
                begin
                    state <= notUCC;
                     return_addr <= pc + 16'h0004;  
                end
            else if (is_first_UCC)
                begin
                    state <= fstUCC;

                end
            else if (is_mid_UCC || is_last_UCC)
                state <= RST;
            else 
                state <= state;
        
        fstUCC:
            if (is_mid_UCC) 
                state <= midUCC;
            else if (is_first_UCC) 
                state <= fstUCC;
            else if (is_last_UCC)
                state <= lastUCC;
            else if (is_outside_UCC) 
                state <= RST;
            else 
                state <= state;
        
        midUCC:
            if (is_mid_UCC)
                state <= midUCC;
            else if (is_last_UCC)
                state <= lastUCC;
            else if (is_first_UCC)
                state <= fstUCC;
            else if (is_outside_UCC)
                state <= RST; 
            else
                state <= state;
            
        lastUCC:
            if (is_outside_UCC && !valid_return)
                state <= RST;
            else if (is_outside_UCC)
                begin
                    state <= notUCC;
                    return_addr <= pc +16'h0004;     
                end
            else if (is_last_UCC) 
                state = lastUCC;
	    else if (is_first_UCC)
		state = fstUCC;
	    else if (is_mid_UCC)
		state = midUCC;
            else state <= state;
                
        RST:
            if (pc == RESET_HANDLER)
                begin
                    state <= notUCC;
                    return_addr <= pc + 16'h0004;  
                end
            else
                state <= state;
                
    endcase
end

////////////// OUTPUT LOGIC //////////////////////////////////////////////
always @(posedge clk)
begin
    if ( (
        (state == fstUCC && !is_in_UCC) ||
        (state == midUCC && !is_in_UCC) ||
        (state == lastUCC && is_outside_UCC && !valid_return) ||
        (state == notUCC && !is_outside_UCC && !is_first_UCC)||
	(state == RST && pc != RESET_HANDLER)
       )
    )begin
            atomicity_reset <= 1'b1;
    end
    else begin
            atomicity_reset <= 1'b0;
    end
end


assign reset = atomicity_reset;

// For formal verification
assign return_address = return_addr;

endmodule
