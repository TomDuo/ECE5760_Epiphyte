module dizzy_buffer (
	data,
	rdaddress,
	rdclock,
	wraddress,
	wrclock,
	wren,
   	q
);


	input	[4:0]  data;
	input	[18:0]  rdaddress;
	input	  rdclock;
	input	[18:0]  wraddress;
	input	  wrclock;
	input	  wren;
	output	[2:0]  q;
    reg [4:0] mem_array [0:307200];
    reg [4:0] qreg;

    assign q = qreg;

    always @(posedge wrclock)
    begin
        if (wren) 
        begin
        mem_array[wraddress] <= data;
        end
    end
    always @(posedge rdclock)
    begin
        qreg <= mem_array[rdaddress];
    end
endmodule


