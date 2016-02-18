#include "globals.h"

/* these globals are written by interrupt service routines; we have to declare 
 * these as volatile to avoid the compiler caching their values in registers */
extern volatile unsigned char byte1, byte2, byte3;	/* modified by PS/2 interrupt service routine */
extern volatile int timeout;								// used to synchronize with the timer
extern struct alt_up_dev up_dev;							/* pointer to struct that holds pointers to
																		open devices */

/* function prototypes */
void HEX_PS2(unsigned char, unsigned char, unsigned char);
void interval_timer_ISR(void *, unsigned int);
void pushbutton_ISR(void *, unsigned int);
void audio_ISR(void *, unsigned int);
void PS2_ISR(void *, unsigned int);

/********************************************************************************
 * This program demonstrates use of the media ports in the DE2 Media Computer
 *
 * It performs the following: 
 *  	1. records audio for about 10 seconds when an interrupt is generated by
 *  	   pressing KEY[1]. LEDG[0] is lit while recording. Audio recording is 
 *  	   controlled by using interrupts
 * 	2. plays the recorded audio when an interrupt is generated by pressing
 * 	   KEY[2]. LEDG[1] is lit while playing. Audio playback is controlled by 
 * 	   using interrupts
 * 	3. Draws a blue box on the VGA display, and places a text string inside
 * 	   the box. Also, moves the word ALTERA around the display, "bouncing" off
 * 	   the blue box and screen edges
 * 	4. Shows a text message on the LCD display, and scrolls the message
 * 	5. Displays the last three bytes of data received from the PS/2 port 
 * 	   on the HEX displays on the DE2 board. The PS/2 port is handled using 
 * 	   interrupts
 * 	6. The speed of scrolling the LCD display and of refreshing the VGA screen
 * 	   are controlled by interrupts from the interval timer
********************************************************************************/
int main(void)
{
	/* declare device driver pointers for devices */
	alt_up_parallel_port_dev *KEY_dev;
	alt_up_parallel_port_dev *green_LEDs_dev;
	alt_up_ps2_dev *PS2_dev;
	alt_up_character_lcd_dev *lcd_dev;
	alt_up_audio_dev *audio_dev;
	alt_up_char_buffer_dev *char_buffer_dev;
	alt_up_pixel_buffer_dma_dev *pixel_buffer_dev;
	/* declare volatile pointer for interval timer, which does not have HAL functions */
	volatile int * interval_timer_ptr = (int *) 0x10002000;	// interal timer base address

	/* initialize some variables */
	byte1 = 0; byte2 = 0; byte3 = 0; 			// used to hold PS/2 data
	timeout = 0;										// synchronize with the timer

	/* these variables are used for a blue box and a "bouncing" ALTERA on the VGA screen */
	int ALT_x1; int ALT_x2; int ALT_y; 
	int ALT_inc_x; int ALT_inc_y;
	int blue_x1; int blue_y1; int blue_x2; int blue_y2; 
	int screen_x; int screen_y; int char_buffer_x; int char_buffer_y;
	short color;

	/* set the interval timer period for scrolling the HEX displays */
	int counter = 0x960000;				// 1/(50 MHz) x (0x960000) ~= 200 msec
	*(interval_timer_ptr + 0x2) = (counter & 0xFFFF);
	*(interval_timer_ptr + 0x3) = (counter >> 16) & 0xFFFF;

	/* start interval timer, enable its interrupts */
	*(interval_timer_ptr + 1) = 0x7;	// STOP = 0, START = 1, CONT = 1, ITO = 1 
	
	// open the pushbuttom KEY parallel port
	KEY_dev = alt_up_parallel_port_open_dev ("/dev/Pushbuttons");
	if ( KEY_dev == NULL)
	{
		alt_printf ("Error: could not open pushbutton KEY device\n");
		return -1;
	}
	else
	{
		alt_printf ("Opened pushbutton KEY device\n");
		up_dev.KEY_dev = KEY_dev;	// store for use by ISRs
	}
	/* write to the pushbutton interrupt mask register, and set 3 mask bits to 1 
	 * (bit 0 is Nios II reset) */
	alt_up_parallel_port_set_interrupt_mask (KEY_dev, 0xE);

	// open the green LEDs parallel port
	green_LEDs_dev = alt_up_parallel_port_open_dev ("/dev/Green_LEDs");
	if ( green_LEDs_dev == NULL)
	{
		alt_printf ("Error: could not open green LEDs device\n");
		return -1;
	}
	else
	{
		alt_printf ("Opened green LEDs device\n");
		up_dev.green_LEDs_dev = green_LEDs_dev;	// store for use by ISRs
	}

	// open the PS2 port
	PS2_dev = alt_up_ps2_open_dev ("/dev/PS2_Port");
	if ( PS2_dev == NULL)
	{
		alt_printf ("Error: could not open PS2 device\n");
		return -1;
	}
	else
	{
		alt_printf ("Opened PS2 device\n");
		up_dev.PS2_dev = PS2_dev;	// store for use by ISRs
	}
	(void) alt_up_ps2_write_data_byte (PS2_dev, 0xFF);		// reset
	alt_up_ps2_enable_read_interrupt (PS2_dev); // enable interrupts from PS/2 port

	// open the audio port
	audio_dev = alt_up_audio_open_dev ("/dev/Audio");
	if ( audio_dev == NULL)
	{
		alt_printf ("Error: could not open audio device\n");
		return -1;
	}
	else
	{
		alt_printf ("Opened audio device\n");
		up_dev.audio_dev = audio_dev;	// store for use by ISRs
	}

	// open the 16x2 character display port
	lcd_dev = alt_up_character_lcd_open_dev ("/dev/Char_LCD_16x2");
	if ( lcd_dev == NULL)
	{
		alt_printf ("Error: could not open character LCD device\n");
		return -1;
	}
	else
	{
		alt_printf ("Opened character LCD device\n");
		up_dev.lcd_dev = lcd_dev;	// store for use by ISRs
	}

	/* use the HAL facility for registering interrupt service routines. */
	/* Note: we are passsing a pointer to up_dev to each ISR (using the context argument) as 
	 * a way of giving the ISR a pointer to every open device. This is useful because some of the
	 * ISRs need to access more than just one device (e.g. the pushbutton ISR accesses both
	 * the pushbutton device and the audio device) */
	alt_irq_register (0, (void *) &up_dev, (void *) interval_timer_ISR);
	alt_irq_register (1, (void *) &up_dev, (void *) pushbutton_ISR);
	alt_irq_register (6, (void *) &up_dev, (void *) audio_ISR);
	alt_irq_register (7, (void *) &up_dev, (void *) PS2_ISR);

	/* create a messages to be displayed on the VGA and LCD displays */
	char text_top_LCD[80] = "Welcome to the DE2-115 Media Computer\0";
	char text_top_VGA[20] = "Altera DE2-115\0";
	char text_bottom_VGA[20] = "Media Computer\0";
	char text_ALTERA[10] = "ALTERA\0";
	char text_erase[10] = "      \0";

	/* output text message to the LCD */
	alt_up_character_lcd_set_cursor_pos (lcd_dev, 0, 0);	// set LCD cursor location to top row
	alt_up_character_lcd_string (lcd_dev, text_top_LCD);
	alt_up_character_lcd_cursor_off (lcd_dev);				// turn off the LCD cursor 

	/* open the pixel buffer */
	pixel_buffer_dev = alt_up_pixel_buffer_dma_open_dev ("/dev/VGA_Pixel_Buffer");
	if ( pixel_buffer_dev == NULL)
		alt_printf ("Error: could not open pixel buffer device\n");
	else
		alt_printf ("Opened pixel buffer device\n");

	/* the following variables give the size of the pixel buffer */
	screen_x = 319; screen_y = 239;
	color = 0x1863;		// a dark grey color
	alt_up_pixel_buffer_dma_draw_box (pixel_buffer_dev, 0, 0, screen_x, 
		screen_y, color, 0); // fill the screen
	
	// draw a medium-blue box in the middle of the screen, using character buffer coordinates
	blue_x1 = 28; blue_x2 = 52; blue_y1 = 26; blue_y2 = 34;
	// character coords * 4 since characters are 4 x 4 pixel buffer coords (8 x 8 VGA coords)
	color = 0x187F;		// a medium blue color
	alt_up_pixel_buffer_dma_draw_box (pixel_buffer_dev, blue_x1 * 4, blue_y1 * 4, blue_x2 * 4, 
		blue_y2 * 4, color, 0);

	/* output text message in the middle of the VGA monitor */
	char_buffer_dev = alt_up_char_buffer_open_dev ("/dev/VGA_Char_Buffer");
	if ( char_buffer_dev == NULL)
		alt_printf ("Error: could not open character buffer device\n");
	else
		alt_printf ("Opened character buffer device\n");

	alt_up_char_buffer_string (char_buffer_dev, text_top_VGA, blue_x1 + 5, blue_y1 + 3);
	alt_up_char_buffer_string (char_buffer_dev, text_bottom_VGA, blue_x1 + 5, blue_y1 + 4);
	
	char_buffer_x = 79; char_buffer_y = 59;
	ALT_x1 = 0; ALT_x2 = 5/* ALTERA = 6 chars */; ALT_y = 0; ALT_inc_x = 1; ALT_inc_y = 1;
	alt_up_char_buffer_string (char_buffer_dev, text_ALTERA, ALT_x1, ALT_y);

	/* this loops "bounces" the word ALTERA around on the VGA screen */
	while (1)
	{
		while (!timeout)
			;	// wait to synchronize with timeout, which is set by the interval timer ISR 

		/* move the ALTERA text around on the VGA screen */
		alt_up_char_buffer_string (char_buffer_dev, text_erase, ALT_x1, ALT_y); // erase
		ALT_x1 += ALT_inc_x; 
		ALT_x2 += ALT_inc_x; 
		ALT_y += ALT_inc_y;

		if ( (ALT_y == char_buffer_y) || (ALT_y == 0) )
			ALT_inc_y = -(ALT_inc_y);
		if ( (ALT_x2 == char_buffer_x) || (ALT_x1 == 0) )
			ALT_inc_x = -(ALT_inc_x);

		if ( (ALT_y >= blue_y1 - 1) && (ALT_y <= blue_y2 + 1) )
		{
			if ( ((ALT_x1 >= blue_x1 - 1) && (ALT_x1 <= blue_x2 + 1)) ||
				((ALT_x2 >= blue_x1 - 1) && (ALT_x2 <= blue_x2 + 1)) )
			{
				if ( (ALT_y == (blue_y1 - 1)) || (ALT_y == (blue_y2 + 1)) )
					ALT_inc_y = -(ALT_inc_y);
				else
					ALT_inc_x = -(ALT_inc_x);
			}
		}
		alt_up_char_buffer_string (char_buffer_dev, text_ALTERA, ALT_x1, ALT_y);

		/* also, display any PS/2 data (from its interrupt service routine) on HEX displays */
		HEX_PS2 (byte1, byte2, byte3);
		timeout = 0;
	}
}

/****************************************************************************************
 * Subroutine to show a string of HEX data on the HEX displays
 * Note that we are using pointer accesses for the HEX displays parallel port. We could
 * also use the HAL functions for these ports instead
****************************************************************************************/
void HEX_PS2(unsigned char b1, unsigned char b2, unsigned char b3)
{
	volatile int *HEX3_HEX0_ptr = (int *) 0x10000020;
	volatile int *HEX7_HEX4_ptr = (int *) 0x10000030;

	/* SEVEN_SEGMENT_DECODE_TABLE gives the on/off settings for all segments in 
	 * a single 7-seg display in the DE2 Media Computer, for the hex digits 0 - F */
	unsigned char	seven_seg_decode_table[] = {	0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 
		  										0x7F, 0x67, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };
	unsigned char	hex_segs[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
	unsigned int shift_buffer, nibble;
	unsigned char code;
	int i;

	shift_buffer = (b1 << 16) | (b2 << 8) | b3;
	for ( i = 0; i < 6; ++i )
	{
		nibble = shift_buffer & 0x0000000F;		// character is in rightmost nibble
		code = seven_seg_decode_table[nibble];
		hex_segs[i] = code;
		shift_buffer = shift_buffer >> 4;
	}
	/* drive the hex displays */
	*(HEX3_HEX0_ptr) = *(int *) (hex_segs);
	*(HEX7_HEX4_ptr) = *(int *) (hex_segs+4);
}
