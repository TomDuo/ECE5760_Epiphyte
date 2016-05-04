module tempoFinder #( 
	parameter beatThreshold = 11'h600
	)(
	input aud_clk,
	input reset,
	input [10:0] iPow,

	output reg [31:0] aud_tics_per_beat
	);

	reg [31:0] tics_counter;
	reg        onBeat;
	always @ (posedge aud_clk) begin
		if ((iPow >= beatThreshold) && (~onBeat)) begin
			aud_tics_per_beat <= tics_counter;
			onBeat <= 1'b1; // make sure you don't reset to zero repeatedly
			tics_counter <= 32'd0;
		end
		else if (iPow < beatThreshold) begin
			onBeat <= 1'b0;
			tics_counter <= tics_counter + 32'd1;
		end
		else begin
			tics_counter <= tics_counter + 32'd1;
		end
	end
endmodule