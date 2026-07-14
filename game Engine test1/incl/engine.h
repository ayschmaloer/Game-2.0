#ifndef ENGINE_H
#define ENGINE_H


#define screen_size_x 16*32
#define screen_size_y 5*32


void init_data();
void drieD_naar_tweeD(int vertex_nr);
void check_input();

void teken_scherm();

void set_screen_buffer(char* buffer, int max_x, int max_y);

#endif

