//========================================================================
// test bench for load balancer
//========================================================================

`timescale 10ps/1ps

module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;
  wire [3:0]  iProcReady;
  wire [3:0]  oDataVal;
  wire [35:0] oDataXSignal;
  wire [35:0] oDataYSignal;
  wire [9:0]  oVGAX;
  wire [8:0]  oVGAY;
  wire        oCoordRdy;
  wire [35:0] iCoordX;
  wire [35:0] iCoordY;
  wire        iCoordVal;
  wire [9:0]  iVGAX;
  wire [8:0]  iVGAY;

  wire m0ProcReady;
  wire m1ProcReady;
  wire m2ProcReady;
  wire m3ProcReady;

  wire [18:0] iProc0VGA;
  wire [18:0] iProc1VGA;
  wire [18:0] iProc2VGA;
  wire [18:0] iProc3VGA;

  wire [7:0]  iProc0Color;
  wire [7:0]  iProc1Color;
  wire [7:0]  iProc2Color;
  wire [7:0]  iProc3Color;

  wire [3:0]  iProcVal;
  wire [3:0]  oProcRdy;

  assign iProcReady[0] = m0ProcReady;
  assign iProcReady[1] = m1ProcReady;
  assign iProcReady[2] = m2ProcReady;
  assign iProcReady[3] = m3ProcReady;
  coordGenerator c1 (
    .clk(clk),
    .reset(reset),

  // inputs from NIOS
  .zoomLevel(4'd0),
  .upperLeftX(~(36'h2_00000000)),
  .upperLeftY(~(36'h1_00000000)),
  .draw(0),

  // inputs from Load Dist
  .iLoadDistRdy(oCoordRdy),

  // outputs to Load Dist
  .oLoadDistVal(iCoordVal),
  .oVGAX(iVGAX),
  .oVGAY(iVGAY),
  .oCoordX(iCoordX),
  .oCoordY(iCoordY)
  );

  loadBalancer #(4) lb1 (
    .clk(clk),
    .reset(reset),

  // input ready signals from processors 
    .iProcReady(iProcReady),
  
  // input from coordinate generation
    .iCoordVal(iCoordVal),
    .iCoordX(iCoordX),
    .iCoordY(iCoordY),
    .iVGAX(iVGAX),
    .iVGAY(iVGAY),

  // output val, ready, signal groups to procs
    .oDataVal(oDataVal),
    .oDataXSignal(oDataXSignal),
    .oDataYSignal(oDataYSignal),
    .oVGAX(oVGAX),
    .oVGAY(oVGAY),

  // output ready, val signal groups to coordinate generator
    .oCoordRdy(oCoordRdy)
  );

  mandlebrotProcessor #(1000) m0 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[0]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m0ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[0]), 

  // signals sent to VGA buffer
    .oColor(iProc0Color),
    .oVGACoord(iProc0VGA),
    .oVGAVal(iProcVal[0])    );

  mandlebrotProcessor #(1000) m1 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[1]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m1ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[1]),

  // signals sent to VGA buffer
    .oColor(iProc1Color),
    .oVGACoord(iProc1VGA),
    .oVGAVal(iProcVal[1])
    );

  mandlebrotProcessor #(1000) m2 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[2]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m2ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[2]),

  // signals sent to VGA buffer
    .oColor(iProc2Color),
    .oVGACoord(iProc2VGA),
    .oVGAVal(iProcVal[2])
    );

  mandlebrotProcessor #(1000) m3 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[3]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m3ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[3]),

  // signals sent to VGA buffer
    .oColor(iProc3Color),
    .oVGACoord(iProc3VGA),
    .oVGAVal(iProcVal[3])
    );

  wire [18:0] arb_addr;
  wire [2:0] arb_data;
  integer rd_addr = 0;
  wire [2:0] buff_out;
  wire arb_wren;
proc2memArb p2m1 (
  .clk(clk),
  .reset(reset),

  // VGA data inputs from processors
  .iProc0VGA(iProc0VGA),
  .iProc1VGA(iProc1VGA),
  .iProc2VGA(iProc2VGA),
  .iProc3VGA(iProc3VGA),

  .iProc0Color(iProc0Color),
  .iProc1Color(iProc1Color),
  .iProc2Color(iProc2Color),
  .iProc3Color(iProc3Color), 

  // ready signals from processors
  .iProcRdy(iProcVal),

  // output signals to processors
  .oProcRdy(oProcRdy),

  // output signals to VGA buffer
  .addr(arb_addr),
  .data(arb_data),
  .w_en(arb_wren)
  );
  dizzy_buffer thedz(
      .data(arb_data),
      .rdaddress(rd_addr),
      .rdclock(clk),
      .wraddress(arb_addr),
      .wrclock(clk),
      .wren(arb_wren),
      .q(buff_out)
  );
        always @(posedge arb_addr) begin
        $display("arb_addr=%d, arb_data=%d",arb_addr,arb_data); 
        end
    integer f;
    initial begin
            // Dump waveforms
    f=$fopen("buffer.csv","w");
    $dumpfile("loadBalancer-sim.vcd");
    $dumpvars;
    #11;
    reset = 1'b0;
    repeat(1000) begin
    #10;
    end
    while(arb_addr < 36'd307200) begin
    //repeat(307200) begin
    #10;
    end
    repeat(307200) begin
        #10
        $fwrite(f,"%d\n",buff_out);
        rd_addr = rd_addr + 1;
    end
    $fclose(f);
    $finish;
end

endmodule

