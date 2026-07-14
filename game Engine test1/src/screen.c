#include "screen.h"
#include "terminal.h"
#include "engine.h"

#include <stdio.h>

char screenbuffer[screen_size_y][screen_size_x] = { 'X' };

void screen_setup() {
	setFontSize(5);


	for (int x = 0; x < screen_size_x; x++) {
		for (int y = 0; y < screen_size_y; y++) {
			screenbuffer[y][x] = '.';
		}
	}


	init_data();



	system("@cls||clear");



}



void screen_run()
{
	clearscreen();

	for (int x = 0; x < screen_size_x; x++) {
		for (int y = 0; y < screen_size_y; y++) {
			screenbuffer[y][x] = ' ';
		}
	}

	check_input();
	teken_scherm();

	set_screen_buffer(&screenbuffer, screen_size_x, screen_size_y);

	clearscreen();

	//system("@cls||clear");
	terminal_print_buffer_to_screen(&screenbuffer, screen_size_x, screen_size_y);


}