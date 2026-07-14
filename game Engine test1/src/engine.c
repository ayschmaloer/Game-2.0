/*
 *
 *   calc_get_2d_point   te dertermain if it fall in frame or not
 *
 *	draw 2d space to determain which pixels hit he triangle
 *	!!! curentlly its all xd !!!
 *
 *	now, or only the hitting triangles:
 *	calc triangle norm
 *	calc intersection points
 *	get distance
 *
 */




#include "engine.h"
#include "math.h"
#include "stdio.h"
#include "stdlib.h"
#include <string.h>

#include "lookup_tables.h"
#include "calculations.h"
#include "obj_reader.h"

#include "GPU.h"


char scale[] = "@MBHENR#KWXDFPQASUZbdehx8Gm&04LOVYkpq5Tagns69owz$CIu23Jcfry%1v7l+it[]{}?j|()=~!-/<>\"^_';,:`.";


const float pov_x = PI / 2;
const float pov_y = PI / 4;


#define max_fortexes 8
Vertex* vertexes;

int* Hits_buffer_counters;
int* Rendered_Vector_Hits;

float angle_x[screen_size_x];
float angle_y[screen_size_y];


int nr_faces = 0;


int precision_factor = 1;


int totaal_nr_renderd_vector_hits = 0;


Coordinate player_coordinates;
float player_angle = 0;
Pixel pixels_Buffer[screen_size_x * screen_size_y];
Pixel pixels_empty_buffer[screen_size_x * screen_size_y] = { 0.0 , 0 };

Player_coordinates player_data;

void render_vertexes();
void render_pixels();
void render_scherm();


void init_data() {
	int global_vertex_size;

	player_coordinates.x = 0;
	player_coordinates.y = 0;
	player_coordinates.z = 5;  // 15;
		
	player_angle = 0;


	load_obj_files(&vertexes, &nr_faces);

	global_vertex_size = ((nr_faces / 1024) + 1) * 1024;
	Hits_buffer_counters = malloc( global_vertex_size * 5 * sizeof(int) );

	Rendered_Vector_Hits = malloc(10000000 * 2 * sizeof(int));

	calc_object_norms(vertexes, nr_faces);

	test_gpu_init(nr_faces);

	gpu_write_vextors(nr_faces, vertexes);

	return 0;

}


void teken_scherm() {


	//clear buffer
	//memcpy(pixels_Buffer, pixels_empty_buffer, sizeof(pixels_Buffer));

	render_vertexes();
	//render_pixels();

	render_scherm();

}





void render_vertexes() {

	player_data.angle = player_angle;
	player_data.x = player_coordinates.x;
	player_data.y = player_coordinates.y;
	player_data.z = player_coordinates.z;
	player_data.nr_faces = nr_faces;
	player_data.cycle = 0;


	//update player
	gpu_write_player_data(&player_data);

	//render coordiates
	gpu_execute_program1(nr_faces);

	//get buffers counters and hits
	gpu_read_vertex_data(Hits_buffer_counters, nr_faces);

	//int ssize = sizeof()

	int count = 0;
	int hits;
	int x_diff, y_diff;
	int vec_count = 0;
	totaal_nr_renderd_vector_hits = 0;

	for (int i = 0; i < nr_faces; i++) {
		hits = Hits_buffer_counters[(i * 5) + 4];
		if (hits <= 0) {
			continue;
		}
		vec_count++;
		int x1 = Hits_buffer_counters[(i * 5) + 0];
		int x2 = Hits_buffer_counters[(i * 5) + 1];
		int y1 = Hits_buffer_counters[(i * 5) + 2];
		int y2 = Hits_buffer_counters[(i * 5) + 3];
		totaal_nr_renderd_vector_hits += hits;
		//x_diff = x2 - x1;
		//y_diff = y2 - y1;

		for (int x = x1; x < x2; x++) {
			for (int y = y1; y < y2; y++) {
				Rendered_Vector_Hits[count++] = i;
				Rendered_Vector_Hits[count++] = x + (16*y);
			}
		}
	}



	if (totaal_nr_renderd_vector_hits > 10000000) {
		while (1) printf("Error");
	}



}



void render_scherm() {

	gpu_write_renderd_hits_data(Rendered_Vector_Hits, totaal_nr_renderd_vector_hits);

	gpu_execute_program2(totaal_nr_renderd_vector_hits, &player_data);

	gpu_read_pixels(pixels_Buffer);

	return;

}




//float ray_angle1 = player_angle - 

/// <summary>
/// Set Graphics
/// </summary>
/// <param name="buffer"></param>
/// <param name="max_x"></param>
/// <param name="max_y"></param>
void set_screen_buffer(char* buffer, int max_x, int max_y) {
	float distance = 0;
	for (int x = 0; x < screen_size_x & x < max_x; x++) {
		for (int y = 0; y < screen_size_y & y < max_y; y++) {

			if (pixels_Buffer[x + (((screen_size_y - 1) - y) * screen_size_x)].item_nr == 0) {
				continue;
			}

			distance = pixels_Buffer[x + (((screen_size_y - 1) - y) * screen_size_x)].distance * precision_factor;
			if (distance > sizeof(scale) - 1) {
				distance = sizeof(scale) - 2;
			}
			*(buffer + x + (y * screen_size_x)) = scale[(int)distance];
		}
	}

	return;
}

int qweqwe = 0;

void check_input() {

	float radiant;
	float new_x = player_coordinates.x;
	float new_y = player_coordinates.y;

	float move_factor = 2;

	char c = 0;

	while (_kbhit())
	{
		c = _getch();
	}

	/*
	if (qweqwe < 50) {
		c = 'd';
	}
	else {
		c = 'a';

	}
	qweqwe++;

	if (qweqwe >= 100) { qweqwe = 0; }
	*/

	radiant = player_angle;


	if (c > 0) {
		switch (c) {
		case 119:
			new_x += sin(radiant) * move_factor;
			new_y += cos(radiant) * move_factor;
			break;
		case 115:
			new_x -= sin(radiant) * move_factor;
			new_y -= cos(radiant) * move_factor;
			break;
		case 100:
			new_x += sin(radiant + PI / 2) * move_factor;
			new_y += cos(radiant + PI / 2) * move_factor;
			break;
		case 97:
			new_x += sin(radiant - PI / 2) * move_factor;
			new_y += cos(radiant - PI / 2) * move_factor;
			break;
		case 75:
			player_angle -= PI / 40;

			if (player_angle < -PI) {
				player_angle += twoPI;
			}
			break;
		case 77:
			player_angle += PI / 40;
			if (player_angle > PI) {
				player_angle -= twoPI;
			}
			break;
		case 'r':
			precision_factor++;
			break;
		case 'f':
			if (precision_factor > 1) {
				precision_factor--;
			}
			break;

		case 'p':
			test_gpu_reinit(nr_faces);
			break;



			
		default:
			;;
		}
	}

	player_coordinates.x = new_x;
	player_coordinates.y = new_y;

	return;
}




