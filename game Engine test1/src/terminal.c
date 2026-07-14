#include "terminal.h"

#include <windows.h>
#include <string.h>
#include <stdio.h>




void setFontSize(int FontSize)
{
	CONSOLE_FONT_INFOEX info = { 0 };
	info.cbSize = sizeof(info);
	info.dwFontSize.Y = FontSize; // leave X as zero
	info.FontWeight = FW_NORMAL;
	wcscpy_s(info.FaceName, sizeof(L"Lucida Console") - 1, L"Lucida Console");
	SetCurrentConsoleFontEx(GetStdHandle(STD_OUTPUT_HANDLE), NULL, &info);
}

void clearscreen()
{
	HANDLE hOut;
	COORD Position;

	hOut = GetStdHandle(STD_OUTPUT_HANDLE);

	Position.X = 0;
	Position.Y = 0;
	SetConsoleCursorPosition(hOut, Position);
}

void set_position_screen(int x, int y)
{
	HANDLE hOut;
	COORD Position;

	hOut = GetStdHandle(STD_OUTPUT_HANDLE);

	Position.X = x;
	Position.Y = y;
	SetConsoleCursorPosition(hOut, Position);
}


void terminal_print_buffer_to_screen(char* buffer, int max_x, int max_y) {
	char* temp_buffer = NULL;
	char space_character = '\n';
	int index_temp = 0;
	int index_p = 0;

	if (!max_x | !max_y) { return;}
	int temp_buffer_size = max_x * max_y + (max_y - 1);

	temp_buffer = malloc(temp_buffer_size);
	if (temp_buffer == NULL) { return; }


	for (int y = 0; y < max_y; y++) {

		if (y > 0) {
			memcpy((temp_buffer + index_temp), &space_character, 1);
			index_temp++;
		}

		memcpy((temp_buffer + index_temp), (buffer + index_p), max_x);

		index_temp += max_x;
		index_p += max_x;
	}


	printf("%.*s \n\n", temp_buffer_size, temp_buffer);
	free(temp_buffer);
}