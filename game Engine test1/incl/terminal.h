#ifndef TERMINAL_H
#define TERMINAL_H


void setFontSize(int FontSize);
void clearscreen();
void set_position_screen(int x, int y);
void terminal_print_buffer_to_screen(char* buffer, int max_x, int max_y);
#endif

