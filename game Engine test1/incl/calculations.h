#ifndef CALCULATIONS_H
#define CALCULATIONS_H
#include "stdbool.h"

#define halfPI 1.570796327
#define PI 3.141592654
#define twoPI 6.283185308


typedef struct {
	float x;
	float y;
	float z;
}Coordinate;

typedef struct {
	float x;
	float y;
}Point;

typedef struct {
	float distance;
	float item_nr;
	//Coordinate Phit;
}Pixel;

typedef struct {
	Coordinate a;
	Coordinate b;
	Coordinate c;
	Coordinate offsett;
	Coordinate Norm;
}Vertex;

typedef struct {
	float d_origin;
	float norm_x;
	float norm_y;
	float norm_z;
	Point A;
	Point B;
	Point C;
	float look_away;
}Rendered_Vertex;

typedef struct {
	float x;
	float y;
	float z;
	float angle;
	float nr_faces;
	float cycle;
}Player_coordinates;




void calc_object_norms(Vertex* vertexes, int nr_faces);

void calc_2d_point(Coordinate destination, Coordinate origin, float player_angle,
	float* ret_distance2, float* ret_angle1, float* ret_angle2);



void calc_normal_2d(float x, float y, float* x_ret, float* y_ret);

int calc_plane(Coordinate a, Coordinate b, Coordinate c, Coordinate Norm,
	Coordinate player_coordinates, float view_angle1, float view_angle2,
	Coordinate* Phit, float* distance);


#endif