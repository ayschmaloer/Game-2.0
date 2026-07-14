
#define halfPI 1.570796327
#define PI 3.141592654
#define twoPI 6.283185308




#define a_x 0
#define a_y 1
#define a_z 2
#define b_x 3
#define b_y 4
#define b_z 5
#define c_x 6
#define c_y 7
#define c_z 8
#define offsett_x 9
#define offsett_y 10
#define offsett_z 11
#define norm_x 12
#define norm_y 13
#define norm_z 14
#define vertex_size 15

#define A_x 15
#define A_y 16
#define B_x 17
#define B_y 18
#define C_x 19
#define C_y 20
#define look_away 21
#define rendered_vertex_size 22

#define player_x 0
#define player_y 1
#define player_z 2
#define player_angle 3
#define player_nr_faces 4
#define player_size 5


#define Pixel_distance 0
#define Pixel_item_nr 1
#define Pixel_size 2


#define screen_size_x 450
#define screen_size_y 150
#define screen_buffer_size  67500		//450 * 150
#define screen_buffer_limit 67584		//1024 * 66

#define pov_x  1.570796327
#define pov_y  0.7853981635

__kernel void render_pixels_kernel(__global const float* Rendered_Vertexes, __global const float* Player, __global float* Rendered_Pixels) {
	float temp_player_x;
	float temp_player_y;

	float d1, d2, d3;
	bool has_neg, has_pos;

	//Rendered_Pixels[0] = Player[player_nr_faces];
	//Rendered_Pixels[1] = Player[player_nr_faces];
	//Rendered_Pixels[2] = 2345;
	//Rendered_Pixels[3] = 6789;


	float angle_x, angle_y, angle_z;

	// Get the index of the current element to be processed
	int i = get_global_id(0);



	int pixer_nr = i % screen_buffer_limit;

	if (pixer_nr >= screen_buffer_size) { return;  }

	int screen_nr = i / screen_buffer_limit;


	int rendered_Pixels_offset = Pixel_size * pixer_nr;
	int renderd_vertex_offset = rendered_vertex_size * screen_nr;




	if (Rendered_Vertexes[renderd_vertex_offset + look_away] > 0) {
		return;
	}


	int x = pixer_nr % screen_size_x;
	int y = pixer_nr / screen_size_x;

	float xfl = x;
	float yfl = y;

	temp_player_x = ((xfl / screen_size_x) - 0.5) * pov_x;
	temp_player_y = ((yfl / screen_size_y) - 0.5) * pov_y;
	

	d1 = (temp_player_x - Rendered_Vertexes[renderd_vertex_offset + B_x]) * (Rendered_Vertexes[renderd_vertex_offset + A_y] - Rendered_Vertexes[renderd_vertex_offset + B_y]) - (Rendered_Vertexes[renderd_vertex_offset + A_x] - Rendered_Vertexes[renderd_vertex_offset + B_x]) * (temp_player_y - Rendered_Vertexes[renderd_vertex_offset + B_y]);
	d2 = (temp_player_x - Rendered_Vertexes[renderd_vertex_offset + C_x]) * (Rendered_Vertexes[renderd_vertex_offset + B_y] - Rendered_Vertexes[renderd_vertex_offset + C_y]) - (Rendered_Vertexes[renderd_vertex_offset + B_x] - Rendered_Vertexes[renderd_vertex_offset + C_x]) * (temp_player_y - Rendered_Vertexes[renderd_vertex_offset + C_y]);
	d3 = (temp_player_x - Rendered_Vertexes[renderd_vertex_offset + A_x]) * (Rendered_Vertexes[renderd_vertex_offset + C_y] - Rendered_Vertexes[renderd_vertex_offset + A_y]) - (Rendered_Vertexes[renderd_vertex_offset + C_x] - Rendered_Vertexes[renderd_vertex_offset + A_x]) * (temp_player_y - Rendered_Vertexes[renderd_vertex_offset + A_y]);

	has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
	has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

	if ((has_neg && has_pos)) {
		return;
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////








	

	angle_x = sin(temp_player_x + Player[player_angle]);
	angle_y = cos(temp_player_x + Player[player_angle]);
	angle_z = sin(temp_player_y );	


	//mormalized
	float w = sqrt((angle_z * angle_z) + (angle_x * angle_x) + (angle_y * angle_y));

	angle_x /= w;
	angle_y /= w;
	angle_z /= w;


	float D = -(Rendered_Vertexes[renderd_vertex_offset + norm_x] * Rendered_Vertexes[renderd_vertex_offset + a_x] + Rendered_Vertexes[renderd_vertex_offset + norm_y] * Rendered_Vertexes[renderd_vertex_offset + a_y] + Rendered_Vertexes[renderd_vertex_offset + norm_z] * Rendered_Vertexes[renderd_vertex_offset + a_z]);     //(Norm, a);
	float _origin = (Player[player_x] * Rendered_Vertexes[renderd_vertex_offset + norm_x] + Player[player_y] * Rendered_Vertexes[renderd_vertex_offset + norm_y] + Player[player_z] * Rendered_Vertexes[renderd_vertex_offset + norm_z]); //(player_coordinates, Norm);
	float _angle = (angle_x * Rendered_Vertexes[renderd_vertex_offset + norm_x] + angle_y * Rendered_Vertexes[renderd_vertex_offset + norm_y]  + angle_z * Rendered_Vertexes[renderd_vertex_offset + norm_z]);  //(angle, Norm);




	///////////////////////////////////////////////////////

	if (_angle == 0) {
		return;
	}

	float t;
	t = -((_origin + D) / _angle);


	/////////////////////////////////////////////////////////

	float p_temp_x = Player[player_x] + t * angle_x;
	float p_temp_y = Player[player_y] + t * angle_y;
	float p_temp_z = Player[player_z] + t * angle_z;


	//Rendered_Pixels[rendered_Pixels_offset + Pixel_Phit_x] = p_temp_x;
	//Rendered_Pixels[rendered_Pixels_offset + Pixel_Phit_y] = p_temp_y;
	//Rendered_Pixels[rendered_Pixels_offset + Pixel_Phit_z] = p_temp_z;

	p_temp_x = t * angle_x;
	p_temp_y = t * angle_y;
	p_temp_z = t * angle_z;


	float Pdistance = sqrt((p_temp_x * p_temp_x) + (p_temp_y * p_temp_y) + (p_temp_z * p_temp_z));

	if (Pdistance > Rendered_Pixels[rendered_Pixels_offset + Pixel_distance]
		& Rendered_Pixels[rendered_Pixels_offset + Pixel_item_nr] != 0)
	{
		return;
	}

	Rendered_Pixels[rendered_Pixels_offset + Pixel_distance] = Pdistance;
	Rendered_Pixels[rendered_Pixels_offset + Pixel_item_nr] = screen_nr + 1;
}
