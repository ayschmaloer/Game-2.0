#ifndef GPU_H
#define GPU_H
#include "calculations.h"

void test_gpu_init(int nr_faces);
void test_gpu_reinit(int nr_faces);

void gpu_write_vextors(int nr_faces, Vertex* vertex_array);
void gpu_write_player_data(Player_coordinates * player_data);
void gpu_execute_program1(int nr_faces);
void gpu_execute_program2(int nr_faces, Player_coordinates* player_data);
void gpu_read_pixels(Pixel* pixel_array);
void gpu_read_vertex_data(int* Hits_buffer_counters, int nr_faces);
void gpu_write_renderd_hits_data(int* Rendered_Vector_Hits, int write_size);

#endif



