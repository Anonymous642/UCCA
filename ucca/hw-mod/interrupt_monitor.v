module interrupt_monitor (
    
// INPUTS
    irq_acc,
    clk,

// OUTPUTS
    irq_jmp
        
);
// OUTPUTS
//=========

output irq_jmp;


// INPUTS
//==========

input        clk;
input [13:0] irq_acc;

reg   [3:0]  delay;
reg          exec;

initial begin 
    delay <= 4'h0;
    exec <= 0;
end


always @(posedge clk)
begin
    if(irq_acc != 14'h0)
        delay <= 4'h1;
    else if(delay == 4)
    begin
        delay <= 4'h0;
        exec <= 1;
    end
    else if(delay > 0)
        delay <= delay + 4'h1;
    else if (exec)
        exec <= 0;
end

assign irq_jmp = exec;

endmodule

