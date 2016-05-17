module tempoFinder #( 
	parameter beatThreshold = 11'h30,
	parameter minTicksPerBeat = 16'd12000, //4hz
	parameter maxTicksPerBeat = 16'd48000 
	)(
	input aud_clk,
	input reset,
	input [10:0] iPow,

	//output reg [31:0] aud_tics_per_beat,
	output reg beating,
	output reg beatHit
	);

	reg [31:0] tics_counter;
	reg [10:0] prevPow;
	reg signed [31:0] tics_at_last_beat;
	reg        onBeat;
	always @ (posedge aud_clk) begin
		if (reset) begin
			tics_counter <= 32'd0;
			tics_at_last_beat <= 32'd0;
			beating <= 1'b0;
			onBeat <= 1'b0;
		end
		if ((iPow >= beatThreshold) && (prevPow < beatThreshold) && (tics_counter-tics_at_last_beat) >= minTicksPerBeat) begin
		//if ((tics_counter-tics_at_last_beat) >= minTicksPerBeat) begin
			onBeat <= 1'b1;
			beating <= 1'b1;
			tics_at_last_beat <= tics_counter;
		end
		else if((tics_counter-tics_at_last_beat) >= maxTicksPerBeat) begin
			beating <= 1'b0;
		end
		else begin
			onBeat <= 1'b0;
		end
		tics_counter <= tics_counter + 32'd1;
		prevPow <= iPow;
			
	end
endmodule