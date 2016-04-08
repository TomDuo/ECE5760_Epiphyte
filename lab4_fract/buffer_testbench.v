//========================================================================
// test bench for load balancer
//========================================================================

`timescale 10ps/1ps

module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;
  wire [2:0] out;
    
  reg [18:0] rdaddress;
  wire[18:0] mbaddress;
  wire[3:0] mbColor;
  wire mbVal;
  integer f;
  integer oVGAX = 0; 
  integer oVGAY = 0;
  dizzy_buffer thedz(
    .data(mbColor[2:0]),
    .rdaddress(rdaddress),
    .rdclock(clk),
    .wraddress(mbaddress),
    .wrclock(clk),
    .wren(mbVal & ~reset),
    .q(out)
  );
  coordGenerator cg(
      .clk(clk),
      .reset(reset),
      .zoomLevel(5'd0),
      .upperLeftX(
  mandlebrotProcessor #() m0 (
    .clk(clk),
    .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m0ProcReady),

  // input from arbitor
    .valueStored(1'b0), 

  // signals sent to VGA buffer
    .oColor(mbColor),
    .oVGACoord(mbaddress),
    .oVGAVal(mbVal)
  );
    integer continue = 1; 
    initial begin
    // Dump waveforms
    f = $fopen("buffer.csv","w");
    $dumpfile("bufferTest-sim.vcd");
    $dumpvars;
    #11;
    reset = 1'b0;
    oVGAX = 0;
    oVGAY = 0;

    while(continue) begin
    #10;
    if(m0ProcReady) begin
        if(oVGAX < 639) begin
            oVGAX = oVGAX+1;
        end
        else if(oVGAY < 479) begin
            oVGAY = oVGAY+1;
            oVGAX = 0;
        end
        else begin
            continue = 0;
        end
    end
    end
    reset = 1'b1;
    #10;
    repeat(307200) begin
        #10
        $fwrite(f,"%d\n",out);
    rdaddress=rdaddress+1;
        end
    $fclose(f);
    $finish;
end

endmodule

