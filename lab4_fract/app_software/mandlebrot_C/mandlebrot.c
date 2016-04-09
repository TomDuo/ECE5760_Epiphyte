#include "address_map.h"
#include "nios2_ctrl_reg_macros.h"
#include "altera_up_avalon_ps2.h"
#include "altera_up_ps2_mouse.h"
#include "head.h"
#include <alt_types.h>
#include <stdio.h>
#include <system.h>
#define lcd_write_command(base, data)                     IOWR(base, 0, data)
#define lcd_read_command(base)                            IORD(base, 1)
#define lcd_write_data(base, data)                    IOWR(base, 2, data)
#define lcd_read_data(base)                           IORD(base, 3) 
#define INTELLIMOUSE 1
	alt_up_ps2_dev * ps2_dev;

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
	
	/*
	alt_up_ps2_write_data_byte(ps2_dev,0xF3); //Set Resolution
		alt_up_ps2_read_data_byte_timeout(ps2_dev, &dumb);

	alt_up_ps2_write_data_byte(ps2_dev,0x03); //8 counts/mm
		alt_up_ps2_read_data_byte_timeout(ps2_dev, &dumb);
	*/
		alt_up_ps2_write_data_byte(ps2_dev,0xF4); //Enable!
		alt_up_ps2_read_data_byte_timeout(ps2_dev, &dumb);

	return mouseID;
	}
int main()
{


	 LCD_Init();   
     LCD_Show_Text("MANDLEBROT");
     	unsigned char mouseID = initMouse();

	int count = 0;
	volatile unsigned char byte1=1, byte2=2, byte3=3,byte4=4, byteX=0x0A,byteY=0x0B,byteZ=0x0C;
	volatile unsigned char oldbyte1=0, oldbyte2=0, oldbyte3=0, oldbyte4=0;
	volatile char buff[50];
	
	alt_up_ps2_clear_fifo(ps2_dev);


	while(1)
	{

		if (read_num_bytes_available(PS2_0_BASE) >= 4)
		{
			alt_up_ps2_read_data_byte(ps2_dev, &byte1);//read 1 byte
			alt_up_ps2_read_data_byte(ps2_dev, &byte2);
			alt_up_ps2_read_data_byte(ps2_dev, &byte3);
			if(INTELLIMOUSE)
				alt_up_ps2_read_data_byte(ps2_dev, &byte4);

			if(byte4 != oldbyte4 || byte1 != oldbyte1 || byte2 != oldbyte2 || byte3 != oldbyte3)
			{
			sprintf(buff,"1=%02x|2=%02x|3=%02x",byte1,byte2,byte3);
			/*
			lcd_write_command(LCD_16207_0_BASE,0x00);
			LCD_Show_Text(buff);
			sprintf(buff,"4=%02x|m=%02x",byte4,mouseID);
			lcd_write_command(LCD_16207_0_BASE,0xC0);
			LCD_Show_Text(buff);
			*/
			}
			oldbyte1=byte1;
			oldbyte2=byte2;
			oldbyte3=byte3;
			oldbyte4=byte4;

			/* DOCUMENTATION CLAIMS THIS
			byteX = byte2;
			byteY = byte3;
			byteZ = byteZ;
			*/
			byteX=byte1;
			byteY=byte2;
			byteZ=byte3;
		}
/*

	if(count == 1000000)
	{
	lcd_write_command(LCD_16207_0_BASE,0x00);
	LCD_Show_Text("xmouse=10");
		lcd_write_command(LCD_16207_0_BASE,0xC0);
	LCD_Show_Text("ymouse=42");
	}
	if(count == 2000000)
	{
	lcd_write_command(LCD_16207_0_BASE,0x00);
	LCD_Show_Text("xmouse=2");
	lcd_write_command(LCD_16207_0_BASE,0xC0);
	LCD_Show_Text("ymouse=4");
	}
		*/
	count ++;

	}

	return 0;
}
