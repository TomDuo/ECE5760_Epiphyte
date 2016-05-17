module tempoFinder #( 
	parameter beatThreshold = 11'h600
	)(
	input aud_clk,
	input reset,
	input [10:0] iPow,

	output reg [31:0] aud_tics_per_beat,
	output reg beatHit
	);

	reg [31:0] tics_counter;
	reg [10:0] prevPow;
	reg signed [31:0] tics_delta;
	reg        onBeat;
	always @ (posedge aud_clk) begin
		if ((iPow >= beatThreshold) && (prevPow < beatThreshold)) begin
			if (tics_counter< 32'd160000) begin
				if (tics_delta < 32'd20000) begin
					aud_tics_per_beat <= tics_counter;
					beatHit <= 1'b1;
				end
			end
			prevPow <= iPow;
			tics_counter <= 32'd0;
		end
		else if (iPow < beatThreshold) begin
			onBeat <= 1'b0;
			tics_counter <= tics_counter + 32'd1;
			beatHit <= 1'b0;
			prevPow <= iPow;
			if (aud_tics_per_beat > tics_counter) begin
				tics_delta <= aud_tics_per_beat - tics_counter;
			end
			else begin
				tics_delta <= tics_counter - aud_tics_per_beat;
			end
		end
		else begin
			tics_counter <= tics_counter + 32'd1;
			beatHit <= 1'b0;
			prevPow <= iPow;
			if (aud_tics_per_beat > tics_counter) begin
				tics_delta <= aud_tics_per_beat - tics_counter;
			end
			else begin
				tics_delta <= tics_counter - aud_tics_per_beat;
			end
		end
	end
endmodule