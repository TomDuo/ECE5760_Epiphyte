
module blockFormat(
	X_COORD,
	Y_COORD,
	value,
	color
);

input 	[9:0] 	X_COORD;
input 	[9:0]		Y_COORD;
input		[1:0]		value;

output	[7:0]		color;



assign color = (X_COORD[9]==1 ?  8'b000_000_00 : //black if x>512
			(value == 2'b00)? 8'b110_000_01:  
			(value == 2'b01)? 8'b001_011_11 :
			(value == 2'b10)? ((X_COORD[5]==0) ? ((Y_COORD[5]==0)? 
			(((5'd12<=X_COORD[4:0])&&(X_COORD[4:0]<=5'd19))? 8'b000_111_00 :
				(((5'd12<=Y_COORD[4:0])&&(Y_COORD[4:0]<=5'd19))? 8'b000_111_00: 8'b001_011_11)) :
				(((5'd12<=X_COORD[4:0])&&(X_COORD[4:0]<=5'd19))? 8'b000_111_00 : 8'b001_011_11)) : 
				(((5'd12<=Y_COORD[4:0])&&(Y_COORD[4:0]<=5'd19))? 8'b000_111_00: 8'b001_011_11))
				
				:
					8'b101_101_00;
//110_000_01




endmodule