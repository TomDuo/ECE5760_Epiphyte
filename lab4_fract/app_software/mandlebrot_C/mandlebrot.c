#include "address_map.h"
#include "nios2_ctrl_reg_macros.h"
#include "head.h"
#define lcd_write_command(base, data)                     IOWR(base, 0, data)
#define lcd_read_command(base)                            IORD(base, 1)
#define lcd_write_data(base, data)                    IOWR(base, 2, data)
#define lcd_read_data(base)                           IORD(base, 3) 

int main()
{
	/*
	alt_up_character_lcd_dev * char_lcd_dev;

	char_lcd_dev = alt_up_character_lcd_open_dev("/dev/Char_LCD_16x2");
	if(char_lcd_dev == NULL)
		alt_printf("Error: could not open character LCD device\n");
	else
		alt_printf("Opened character LCD device\n");

	alt_up_character_lcd_init(char_lcd_dev);
	alt_up_character_lcd_string(char_lcd_dev,"Stitches BIYF");
	*/
	 LCD_Init();   
     LCD_Show_Text("MANDLEBROT");
	int count = 0;
	while(1)
	{
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
	count ++;
	}
	return 0;
}
