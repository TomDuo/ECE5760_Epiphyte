module cross_clocker #(

	parameter signal_width = 9
)
(
    input dest_clk,  
    input [signal_width-1:0] sig_in,
    output wire [signal_width-1:0]sig_out
);

// We use a two-stages shift-register to synchronize SignalIn_clkA to the clkB clock domain
reg [signal_width-1:0] first;
reg [signal_width-1:0] second;
always @(posedge dest_clk) 
begin
first  <= sig_in;
second <= first;
end

assign sig_out = second; 
endmodule
