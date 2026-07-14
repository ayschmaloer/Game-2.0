#include "obj_reader.h"

#include "engine.h"
#include "math.h"
#include "stdio.h"
#include "stdlib.h"
#include <string.h>

#include "calculations.h"

#define FILENAME_STR "map.obj"  //"barracks7.obj"   //"Rabbit_Lowpoly_1.obj" "testcube.obj"   


Coordinate* vertices;
Coordinate* textures;
Coordinate* normals;



FILE* stream = NULL;




int file_obj_count_nr(int* nr_faces, int* nr_vertices, int* nr_textures, int* nr_normals);
void file_obj_read_file(Vertex* vertexes);


int Y_offset = 20;
int ffactor = 1;



void load_obj_files(Vertex** vertexes, int* total_nr_faces) {
	int nr_vertices = 0;
	int nr_textures = 0;
	int nr_normals = 0;

	fopen_s(&stream, FILENAME_STR, "rb");

	if (stream == NULL) {
		printf("NOPE");
		while (1) { ;; }
	}
	printf("okee\n");




	file_obj_count_nr(total_nr_faces, &nr_vertices, &nr_textures, &nr_normals);
	fclose(stream);


	*vertexes = malloc(sizeof(Vertex) * (*total_nr_faces));
	vertices = malloc(sizeof(Coordinate) * nr_vertices);
	textures = malloc(sizeof(Coordinate) * nr_textures);
	normals = malloc(sizeof(Coordinate) * nr_normals);

	//stream = NULL;

	fopen_s(&stream, FILENAME_STR, "rb");

	if (stream == NULL) {
		printf("NOPE");
		while (1) { ;; }
	}
	printf("okee\n");


	file_obj_read_file(*vertexes);
	fclose(stream);



	free(vertices);
	free(textures);
	free(normals);

	printf("finished loading\n");
	return;
}


int nr_vertices = 0;
int nr_textures = 0;
int nr_normals = 0;


int file_obj_count_nr(int* nr_faces, int * nr_vertices, int * nr_textures, int* nr_normals){
	int ch;

	if (stream == NULL) {
		printf("NOPE");
		while (1) { ;; }
	}


	while (1) {
		ch = fgetc(stream);
		if (ch == EOF) {
			break;
		}

		if (ch == '#') {

			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}


		else if (ch == 'o') {

			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}


		else if (ch == 's') {

			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}


		else if (ch == 'v') {


			ch = fgetc(stream);
			if (ch == EOF) {
				break;
			}


			if (ch == ' ') {
				(*nr_vertices)++;
			}
			if (ch == 't') {
				(*nr_textures)++;
			}
			if (ch == 'n') {
				(*nr_normals)++;
			}

			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}
		else if (ch == 'f') {
			(*nr_faces)++;
			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}
		else {
			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}

	}

	return 0;
}



void file_obj_read_file(Vertex* vertexes) {
	int ch = 0;
	int faces_it = 0;
	int vertices_it = 0;
	int textures_it = 0;
	int normals_it = 0;

	if (stream == NULL) {
		printf("NOPE");
		while (1) { ;; }
	}







	while (1) {

		ch = fgetc(stream);
		if (ch == EOF) {
			break;
		}

		if (ch == '#') {

			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}


		else if (ch == 'o') {

			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}


		else if (ch == 's') {

			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}


		else if (ch == 'v') {


			ch = fgetc(stream);
			if (ch == EOF) {
				break;
			}


			if (ch == ' ') {



				ch = _read_float_values(&vertices[vertices_it]);

				if (ch == EOF) {
					break;
				}

				vertices_it++;
			}
			if (ch == 't') {


				ch = fgetc(stream);
				if (ch == EOF) {
					break;
				}


				ch = _read_float_values( &textures[textures_it]);
				if (ch == EOF) {
					break;
				}
				textures_it++;



			}
			if (ch == 'n') {



				ch = fgetc(stream);
				if (ch == EOF) {
					break;
				}



				ch = _read_float_values(&normals[normals_it]);
				if (ch == EOF) {
					break;
				}

				normals_it++;

			}




		}



		else if (ch == 'f') {
			//remove ' '
			ch = fgetc(stream);
			if (ch == EOF) {
				break;
			}

			ch = _read_vertexes(&vertexes[faces_it]);
			if (ch == EOF) {
				break;
			}

			faces_it++;
		}
		else {
			ch = _skip_till_breakline();
			if (ch == EOF) {
				break;
			}
		}

	}








	return;
}





int _read_vertexes(Vertex* vertexes) {
	int count1 = 0;
	int count2 = 0;

	int temp[3] = { 0 };

	int ch = 0;



	ch = fgetc(stream);



	while (ch != '\n' & ch != EOF) {


		switch (ch) {

		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':

			if (count1 % 3 == 0) {
				temp[count2] *= 10;
				temp[count2] += (ch - '0');
			}


			break;

		case '/':


			count1++;
			break;

		case ' ':


			count2++;
			count1++;
			break;

		default:
			;;
		}






		ch = fgetc(stream);

	}

	vertexes->a = vertices[temp[0] - 1];
	vertexes->b = vertices[temp[1] - 1];
	vertexes->c = vertices[temp[2] - 1];

	return ch;
}







int _read_float_values(Coordinate* coordinates) {
	int count1 = 0;
	int count2 = 0;
	int sign = 1.0;
	float temp = 0;
	int ch = 0;

	int prev = 0;



	ch = fgetc(stream);



	while (ch != '\n' & ch != EOF) {



		switch (ch) {
		case '-':
			sign = -1.0;
			break;

		case '.':
			count2++;
			count1 = 0;
			break;

		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			if (count1 == 0 & count2 % 2 == 0) {
				temp = sign * (ch - '0');
			}

			else if (count2 % 2 == 0) {
				temp *= 10;
				temp += sign * (ch - '0');
			}

			else if (count2 % 2 == 1) {
				temp += sign * ((float)ch - '0') / powf(10, count1 + 1);
			}

			count1++;

			break;
		case ' ':

			if (count2 < 2) {
				coordinates->x = temp * ffactor;
			}
			else if (count2 < 4) {
				coordinates->z = temp * ffactor;
			}
			else {
				coordinates->y = (-temp * ffactor) + Y_offset;///////
			}

			temp = 0;
			sign = 1.0;
			count2++;
			count1 = 0;
			break;

		default:
			;;
		}

		prev = ch;
		ch = fgetc(stream);
	}

	coordinates->y = (-temp * ffactor) + Y_offset;

	return ch;
}


int _skip_till_breakline() {
	int ch = 0;
	ch = fgetc(stream);

	while (ch != '\n' & ch != EOF) {

		ch = fgetc(stream);

	}

	return ch;
}