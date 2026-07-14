#include "calculations.h"
#include "math.h"

float length(Coordinate a);
Coordinate normalize(Coordinate x);



void calc_object_norms(Vertex* vertexes, int nr_faces) {

	Coordinate AB;
	Coordinate AC;

	Coordinate Norm;

	Coordinate P;

	for (int itt = 0; itt < nr_faces; itt++) {

		AB.x = vertexes[itt].b.x - vertexes[itt].a.x;
		AB.y = vertexes[itt].b.y - vertexes[itt].a.y;
		AB.z = vertexes[itt].b.z - vertexes[itt].a.z;

		AC.x = vertexes[itt].c.x - vertexes[itt].a.x;
		AC.y = vertexes[itt].c.y - vertexes[itt].a.y;
		AC.z = vertexes[itt].c.z - vertexes[itt].a.z;


		Norm.x = AB.y * AC.z - AB.z * AC.y;
		Norm.y = AB.z * AC.x - AB.x * AC.z;
		Norm.z = AB.x * AC.y - AB.y * AC.x;

		Norm = normalize(Norm);

		vertexes[itt].Norm = Norm;
	}
	return;
}





void calc_2d_point(Coordinate destination, Coordinate origin, float player_angle,
	float* ret_distance2, float* ret_angle1, float* ret_angle2) {



	float x_diff = destination.x - origin.x;
	float y_diff = destination.y - origin.y;



	*ret_angle1 = atan2f(x_diff, y_diff);
	*ret_angle1 -= player_angle;

	while (*ret_angle1 > PI) {
		*ret_angle1 -= twoPI;
	}
	while (*ret_angle1 < -PI) {
		*ret_angle1 += twoPI;
	}



	float ret_distance1 = sqrtf((x_diff * x_diff) + (y_diff * y_diff));

	float z_diff = destination.z - origin.z;
	*ret_angle2 = atan2f(z_diff, ret_distance1);
	*ret_distance2 = sqrtf((z_diff * z_diff) + (ret_distance1 * ret_distance1));

	return;
}
















float dot(Coordinate a, Coordinate b) {
	float result;

	result = a.x * b.x + a.y * b.y + a.z * b.z;

	return result;
}


Coordinate normalize(Coordinate x) {
	float w = 0;
	Coordinate result;
	w = length(x);


	result.x = x.x / w;
	result.y = x.y / w;
	result.z = x.z / w;

	return result;
}


float length(Coordinate a) {
	return sqrtf((a.z * a.z) + (a.x * a.x) + (a.y * a.y));
}


int calc_plane(Coordinate a, Coordinate b, Coordinate c, Coordinate Norm,
	Coordinate player_coordinates, float view_angle1, float view_angle2,
	Coordinate* Phit, float* distance) {

	//!!!!!!!!!!!!!!!!!!!
	Coordinate angle;
	//view_angle1 = (view_angle1 / 180 * PI);
	//view_angle2 = (view_angle2 / 180 * PI);

	angle.x = sin(view_angle1);			//0.2;//sin(view_angle);
	angle.y = cos(view_angle1);			//0.97979798;//cos(view_angle);
	angle.z = sin(view_angle2);			//0;
	angle = normalize(angle);




	float D = -dot(Norm, a);
	float _origin = dot(player_coordinates, Norm);
	float _angle = dot(angle, Norm);

	if (_angle == 0) {
		return 1;
	}

	float t;
	t = -((_origin + D) / _angle);


	////////////////////////
	Coordinate p_temp;
	p_temp.x = player_coordinates.x + t * angle.x;
	p_temp.y = player_coordinates.y + t * angle.y;
	p_temp.z = player_coordinates.z + t * angle.z;



	*Phit = p_temp;

	p_temp.x = t * angle.x;
	p_temp.y = t * angle.y;
	p_temp.z = t * angle.z;

	*distance = length(p_temp);

	return 0;
}


