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

  assign iProcReady[0] = m0ProcReady;
  assign iProcReady[1] = m1ProcReady;
  assign iProcReady[2] = m2ProcReady;
  assign iProcReady[3] = m3ProcReady;
  coordGenerator c1 (
    .clk(clk),
    .reset(reset),

  // inputs from NIOS
  .zoomLevel(4'd0),
  .upperLeftX(36'hF_00000000),
  .upperLeftY(36'hF_00000000),
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

  mandlebrotProcessor #(100) m0 (
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
    .oColor(iProcColor[0]),
    .oVGACoord(iProcVGA[0]),
    .oVGAVal(iProcVal[0])    );

  mandlebrotProcessor #(100) m1 (
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
    .oColor(iProcColor[1]),
    .oVGACoord(iProcVGA[1]),
    .oVGAVal(iProcVal[1])
    );

  mandlebrotProcessor #(100) m2 (
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
    .oColor(iProcColor[2]),
    .oVGACoord(iProcVGA[2]),
    .oVGAVal(iProcVal[2])
    );

  mandlebrotProcessor #(100) m3 (
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
    .oColor(iProcColor[3]),
    .oVGACoord(iProcVGA[3]),
    .oVGAVal(iProcVal[3])
    );

wire [18:0] iProcVGA   [0:3];
wire [7:0]  iProcColor [0:3];
wire [3:0]  iProcVal;
wire [3:0]  oProcRdy;

proc2memArb p2m1 (
  .clk(clk),
  .reset(reset),

  // VGA data inputs from processors
  .iProcVGA(iProcVGA),
  .iProcColor(iProcColor), 

  // ready signals from processors
  .iProcRdy(iProcVal),

  // output signals to processors
  .oProcRdy(oProcRdy),

  // output signals to VGA buffer
  .addr(),
  .color(),
  .w_en()
  );
    initial begin

    // Dump waveforms
    $dumpfile("loadBalancer-sim.vcd");
    $dumpvars;
    #11;
    reset = 1'b0;

    repeat(6000) begin
    #10;
    end
    $finish;
end

endmodule

