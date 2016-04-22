module verilogGPIO(
	// general pins
	input clk,
	input reset,

	// input pins from the GPIO
	input         exp_present, 
	input         exp_spi_miso, 
	input         exp_clock_in,

	// output pins to the GPIO
	output        exp_spi_clock,
	output        exp_spi_mosi,

	// I/O pins from the GPIO
	inout reg [32:2] exp_gpio_pin
);

wire [31:0] exp_gpio_dir;
reg  [31:0] exp_gpio_read; // when the direction is read, pins are saved here
reg  [31:0] exp_gpio_write; // when the direction is write, pins written from here

localparam read  = 1'b0;
localparam write = 1'b1;

// get the input and the output from the bidirectional port
genvar i;
generate
for (i = 0; i < 31 ; i = i + 1) begin: 
    bidirec ioioio(
		.oe(exp_gpio_dir[i]),
		.clk(clk),
		.inp(exp_gpio_write[i]),
		.outp(exp_gpio_read[i]),
		.bidir(exp_gpio_pin[i+1])
	);
end
endgenerate

// assign input values from switches
wire SW10;
assign SW10 = exp_spi_miso;

wire SW9;
assign SW9 = exp_present;

wire SW8;
assign SW8 = exp_gpio_read[17];
assign exp_gpio_dir[17] = read;

wire SW7;
assign SW7 = exp_gpio_read[18];
assign exp_gpio_dir[18] = read;

wire SW6;
assign SW6 = exp_gpio_read[19];
assign exp_gpio_dir[19] = read;

wire SW1_1;
assign SW1_1 = exp_gpio_read[27];
assign exp_gpio_dir[27] = read;

wire SW1_2;
assign SW1_2 = exp_gpio_read[26];
assign exp_gpio_dir[26] = read;

wire SW1_3;
assign SW1_3 = exp_gpio_read[16];
assign exp_gpio_dir[16] = read;

wire SW1_4;
assign SW1_4 = exp_gpio_read[15];
assign exp_gpio_dir[15] = read;

// set the outputs for the LEDs
reg TLED_B;
assign exp_gpio_dir[20] = write;

reg TLED_G;
assign exp_gpio_dir[21] = write;

reg TLED_R;
assign exp_gpio_dir[22] = write;

reg LED8;
assign exp_gpio_dir[29] = write;

reg LED7;
assign exp_gpio_dir[31] = write;

reg LED6;
assign exp_gpio_dir[25] = write;

reg LED5;
assign exp_gpio_dir[23] = write;

reg LED4;
assign exp_gpio_dir[28] = write;

reg LED3;
assign exp_gpio_dir[30] = write;

reg LED2;
assign exp_gpio_dir[32] = write;

reg LED1;
assign exp_gpio_dir[24] = write;

always @ (posedge clk) begin
	exp_gpio_write[20] <= TLED_B;
	exp_gpio_write[21] <= TLED_G;
	exp_gpio_write[22] <= TLED_R;
	exp_gpio_write[29] <= LED8;
	exp_gpio_write[31] <= LED7;
	exp_gpio_write[25] <= LED6;
	exp_gpio_write[23] <= LED5;
	exp_gpio_write[28] <= LED4;
	exp_gpio_write[30] <= LED3;
	exp_gpio_write[32] <= LED2;
	exp_gpio_write[24] <= LED1;
end

// the rest are GPIO that we can set however we want
//EXP_SPI_CLK = GPIO_16
//EXP_SPI_MISO = GPIO_15
//EXP_GPIO_1 = GPIO_14
//EXP_GPIO_2 = GPIO_13
//EXP_GPIO_3 = GPIO_12
//EXP_GPIO_4 = GPIO_11
//EXP_GPIO_5 = GPIO_10
//EXP_GPIO_6 = GPIO_9
//EXP_GPIO_7 = GPIO_8
//EXP_GPIO_8 = GPIO_7
//EXP_GPIO_9 = GPIO_6
//EXP_GPIO_10 = GPIO_5
//EXP_GPIO_11 = GPIO_4
//EXP_GPIO_12 = GPIO_3
//EXP_GPIO_13 = GPIO_2
//EXP_GPIO_14 = GPIO_1
endmodule