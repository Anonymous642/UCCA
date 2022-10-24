module region_validity (
/// INPUT ///////////////////////////////////////
    clk,
    pc,
    region_start,
    region_stop,

/// OUTPUT //////////////////////////////////////
    reset
);
input        clk;
input [15:0] pc;
input [15:0] region_start;
input [15:0] region_stop;

output       reset;

/// FSM States //////////////////////////////////
parameter RUN = 1'b0;
parameter RST = 1'b1;
/////////////////////////////////////////////////
parameter RESET_HANDLER = 16'h0000;

wire is_valid = region_start < region_stop;

reg state;
reg validity_reset;

initial
begin
    state = RST;
    validity_reset = 1'b1;
end

always @(posedge clk) 
begin
    case (state)
        RUN:
            if (is_valid)
                state <= state;
            else
                state <= RST;    
        RST:
            if (pc == RESET_HANDLER)
                state <= RUN;
            else
                state <= state;
    endcase
end

/// OUTPUT LOGIC ////////////////////////////////
always @(posedge clk)
begin
    if ( (state == RUN && !is_valid) || 
         (state == RST && pc != RESET_HANDLER)
       )
        validity_reset <= 1'b1;
    else
        validity_reset <= 1'b0;
end

assign reset = validity_reset;

endmodule

