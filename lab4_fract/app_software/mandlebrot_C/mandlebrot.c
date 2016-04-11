#include "address_map.h"
#include "nios2_ctrl_reg_macros.h"
#include "altera_up_avalon_ps2.h"
#include "altera_up_ps2_mouse.h"
#include "head.h"
#include <alt_types.h>
#include <stdint.h>
#include <stdio.h>
#include <system.h>
#define lcd_write_command(base, data)                     IOWR(base, 0, data)
#define lcd_read_command(base)                            IORD(base, 1)
#define lcd_write_data(base, data)                    IOWR(base, 2, data)
#define lcd_read_data(base)                           IORD(base, 3) 
#define INTELLIMOUSE 1
#define WINDOWLENGTH 40
alt_up_ps2_dev * ps2_dev;
volatile int * cursor_update_clk_ptr = (int *) CURSOR_UPDATE_CLK_BASE;
volatile int * nios_cursorX_ptr = (int *) NIOS_CURSORX_BASE;
volatile int * nios_cursorY_ptr = (int *) NIOS_CURSORY_BASE;
volatile int * nios_zoom_ptr = (int *) NIOS_ZOOM_BASE;
volatile int * nios_upper_left_x_ptr = (int *) NIOS_UPPER_LEFTX_BASE;
volatile int * nios_upper_left_y_ptr = (int *) NIOS_UPPER_LEFTY_BASE;

unsigned char initMouse()
	{
	volatile unsigned char mouseID=0xdd, status1=1, status2=2,status3=3,status4=4, dumb;
	ps2_dev = alt_up_ps2_open_dev("/dev/ps2_0"); 
	alt_up_ps2_clear_fifo(ps2_dev);
	int i;
	for(i =0; i < 4; i++) //Send reset sequence four  times
	{
	alt_up_ps2_write_data_byte(ps2_dev,0xFF); //Reset
	alt_up_ps2_read_data_byte_timeout(ps2_dev, &dumb);
	alt_up_ps2_read_data_byte_timeout(ps2_dev, &dumb);
	alt_up_ps2_read_data_byte_timeout(ps2_dev, &mouseID);
	}

	volatile unsigned char all_status=0;
	all_status |= (status1 << 3) | (status2<<2) | (status3<<1) | status4;
	all_status = status1;
	if(INTELLIMOUSE)
	{

		alt_up_ps2_write_data_byte_with_ack(ps2_dev,0xF3); //Set sample rate
		alt_up_ps2_write_data_byte_with_ack(ps2_dev,0xc8); //Set sample rate
		alt_up_ps2_write_data_byte_with_ack(ps2_dev,0xF3); //Set sample rate
		alt_up_ps2_write_data_byte_with_ack(ps2_dev,0x64); //Set sample rate
		alt_up_ps2_write_data_byte_with_ack(ps2_dev,0xF3); //Set sample rate
		alt_up_ps2_write_data_byte_with_ack(ps2_dev,0x50); //Set sample rate
	}
	alt_up_ps2_write_data_byte(ps2_dev,0xF2); //Reset
	alt_up_ps2_read_data_byte_timeout(ps2_dev, &dumb);
	alt_up_ps2_read_data_byte_timeout(ps2_dev, &mouseID); //Get Device ID
	alt_up_ps2_write_data_byte_with_ack(ps2_dev,0xF3); //Set sample rate
	alt_up_ps2_write_data_byte_with_ack(ps2_dev,20); //Set sample rate

	/*
	alt_up_ps2_write_data_byte(ps2_dev,0xF3); //Set Resolution
		alt_up_ps2_read_data_byte_timeout(ps2_dev, &dumb);

	alt_up_ps2_write_data_byte(ps2_dev,0x03); //8 counts/mm
		alt_up_ps2_read_data_byte_timeout(ps2_dev, &dumb);
	*/


	return mouseID;
	}
int main()
{
	*(cursor_update_clk_ptr) = 0;


	LCD_Init();   
    LCD_Show_Text("MANDLEBROT");
    uint16_t count = 0;
	volatile signed char byte1=0, byte2=0, byte3=0,byte4=0;
	volatile signed char byteX=0x0A,byteY=0x0B,byteZ=0x0C;
	//volatile signed char oldbyte1=0, oldbyte2=0, oldbyte3=0, oldbyte4=0;
	volatile char buff[50];
	int32_t xCursor=200;
	int32_t yCursor=200;
	int32_t prev_upperLeftX = ~(0x20000001); 
	int32_t prev_upperLeftY = ~(0x10000001);
	float upperLeftX[16]; 
	float upperLeftY[16];

	upperLeftX[0] = -2.0f;
	upperLeftY[0] = -1.0f;
    unsigned char mouseID = initMouse();


	
	//alt_up_ps2_clear_fifo(ps2_dev);

	alt_up_ps2_write_data_byte(ps2_dev,0xF4); //Enable!
	alt_up_ps2_read_data_byte(ps2_dev, NULL);
	uint8_t status;

	uint8_t left_pressed = 0;
	uint8_t right_pressed = 0;
	uint8_t left_history[WINDOWLENGTH]  = { 0 };
	uint8_t right_history[WINDOWLENGTH] = { 0 };
	uint16_t zoom = 0;
	uint16_t oldZoom = 0;
	uint16_t zoom_count = 0;
	uint8_t i;
	while(1)
	{
		if (zoom_count > 1000)
		{
			zoom_count = 1000;
		}
		else 
		{
			zoom_count++;
		}

		uint16_t ravail=read_num_bytes_available(PS2_0_BASE);	
		if (ravail !=0)
		{
			status=0;
			status |= alt_up_ps2_read_data_byte(ps2_dev, &byte1);//read 1 byte
			status |=alt_up_ps2_read_data_byte(ps2_dev, &byte2);
			status |=alt_up_ps2_read_data_byte(ps2_dev, &byte3);
			if(INTELLIMOUSE) {
				status |=alt_up_ps2_read_data_byte(ps2_dev, &byte4);
			}
			
			if(INTELLIMOUSE)
			{
				byteX = byte2;
				byteY = byte3;
				byteZ = byte4;
			}
			else
			{
				byteX=byte2;
				byteY=byte3;
			}

			/*
			byteX=byte1;
			byteY=byte2;
			byteZ=byte3;
			*/
			unsigned char y_overflow = ((byte1 & (1<<7))>>7);
			unsigned char x_overflow = ((byte1 & (1<<6))>>6);
			int16_t y_delta = ((byte1 & (1<<5) << 3) )| byteY;
			y_delta = -1*y_delta;
			int16_t x_delta = ((byte1 & (1<<4) << 4) )| byteX;
			unsigned char filtered_left_pressed;
			unsigned char filtered_right_pressed;
			x_delta = x_delta/8;
			y_delta = y_delta/8;
			if(status == 0)
			{

			
				// NOAH, I ADDED STUFF HERE -----------------------------------------------------------
				/*
				for (i=0;i<WINDOWLENGTH;i++)
				{
					left_history[i] = left_history[i+1];
					right_history[i] = right_history[i+1];
				}
				left_pressed =  byte1 & 1;
				right_pressed =  (byte1 & (1<<1) )>>1;
				left_history[WINDOWLENGTH]  = left_pressed;
				right_history[WINDOWLENGTH] = right_pressed;
				filtered_left_pressed = 0;
				filtered_right_pressed = 0;
				for (i=0;i<WINDOWLENGTH;i++)
				{
					if (left_history[i] == left_pressed) filtered_left_pressed++;
					if (right_history[i] == right_pressed) filtered_right_pressed++;
				}
				*/
				// ------------------------------------------------------------------------------------
				

				if( (abs(x_delta) < 20) && xCursor + x_delta >= 0 && xCursor + x_delta < 640)
				{
					xCursor += x_delta;
				}
				if( (abs(y_delta) < 20) && yCursor + y_delta >= 0 && yCursor + y_delta < 480)
				{
					yCursor += y_delta;
				}
				
				if(x_delta == 0 && y_delta == 0 && (zoom <= 31) && (left_pressed != (byte1 & 1) ) && (zoom_count >= 200) )// (byte1 & 1)) //Left button posedge
				{
					zoom++;
					zoom_count = 0;
				}
				if(x_delta == 0 && y_delta == 0 && (zoom != 0)  && (right_pressed != ((byte1 & (1<<1) )>>1)) && (zoom_count >= 200) )//((byte1 & (1<<1))>>1) ) 
				{
					zoom--;
					zoom_count = 0;

				}
				left_pressed =  byte1 & 1;
				right_pressed =  (byte1 & (1<<1) )>>1;

				/*
				if( (zoom <= 31) && (left_history[0] == 0) && (filtered_left_pressed == (WINDOWLENGTH-1)) && (left_history[7] == 1) )// (byte1 & 1)) //Left button posedge
				{
					zoom++;
				}
				if( (zoom != 0)  && (right_history[0] == 0) && (filtered_right_pressed == (WINDOWLENGTH-1)) && (right_history[7] == 1) )//((byte1 & (1<<1))>>1) ) 
				{
					zoom--;

				}
				*/
			}

		}
		if(count >= 20)
		{
		*(cursor_update_clk_ptr) = 0;

		float cursorFloatX = upperLeftX[oldZoom] + 3.0f*(float)xCursor/((1<<oldZoom)*640.0f);
		float cursorFloatY = upperLeftY[oldZoom] + 2.0f*(float)yCursor/((1<<oldZoom)*480.0f);
		if(oldZoom < zoom)
		{
			upperLeftX[zoom] = cursorFloatX;
			upperLeftY[zoom] = cursorFloatY;
			xCursor=0;
			yCursor=0;
		}
		if(oldZoom > zoom)
		{
			//do nothing!!
		xCursor=0;
			yCursor=0;
		}

		int32_t fixed_pt_upperLeftX = (int32_t)(upperLeftX[zoom]*268435456.0f);
		int32_t fixed_pt_upperLeftY = (int32_t)(upperLeftY[zoom]*268435456.0f);

		
		oldZoom = zoom;
		sprintf(buff," X=%i|Y=%i|Z=%i",xCursor,yCursor,zoom);

		lcd_write_command(LCD_16207_0_BASE,0x00);
		LCD_Show_Text(buff);
		
		lcd_write_command(LCD_16207_0_BASE,0xC0);
		//sprintf(buff,"zoom=%i",zoom);
		sprintf(buff,"%1.4f_%1.4f",cursorFloatX,cursorFloatY);

		LCD_Show_Text(buff);
		*(nios_cursorX_ptr) = xCursor;
		*(nios_cursorY_ptr) = yCursor;
		*(nios_upper_left_x_ptr) = fixed_pt_upperLeftX;
		*(nios_upper_left_y_ptr) = fixed_pt_upperLeftY;

		*(nios_zoom_ptr)    = zoom;
		*(cursor_update_clk_ptr) = 1;

		count=0;
		}
	count ++;
	}

	return 0;
}
