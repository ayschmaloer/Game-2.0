
#define halfPI 1.570796327
#define PI 3.141592654
#define twoPI 6.283185308




#define d_origin 0
#define r_norm_x 1
#define r_norm_y 2
#define r_norm_z 3
#define A_x 4
#define A_y 5
#define B_x 6
#define B_y 7
#define C_x 8
#define C_y 9
#define rendered_vertex_size 10


#define player_x 0
#define player_y 1
#define player_z 2
#define player_angle 3
#define player_nr_faces 4
#define player_cycle 5
#define player_size 6


#define Pixel_distance 0
#define Pixel_item_nr 1
#define Pixel_size 2


#define screen_size_x 512
#define screen_size_y 160
#define screen_buffer_size  81920		//512 * 160

#define pov_x  1.570796327
#define pov_y  0.7853981635

#define max_nr_vertexes 2147483040


__kernel void render_pixels_kernel(__global float* Rendered_Vertexes, __global const float* Player, __global const int * Renderd_Hits,  __global float* Rendered_Pixels) {
	float temp_player_x;
	float temp_player_y;

	float d1, d2, d3;
	bool has_neg, has_pos;

	//Rendered_Pixels[0] = local_Player[player_nr_faces];
	//Rendered_Pixels[1] = local_Player[player_nr_faces];
	//Rendered_Pixels[2] = 2345;
	//Rendered_Pixels[3] = 6789;


	float angle_x, angle_y, angle_z;

	float p_temp_x;
	float p_temp_y;
	float p_temp_z;


	/*
 Get the index of the current element to be processed
	int i = get_global_id(0);


	int pixer_nr = i % screen_buffer_size;

	int screen_nr = i / screen_buffer_size;

	screen_nr += 26214 * Player[player_cycle];

	int max_nr;
	max_nr = hex7ffffff / (screen_size_x * screen_size_y); //max nr of vexers per full int
	max_nr = max_nr * (screen_size_x * screen_size_y);  //max nr of vexers per full int

	int rendered_Pixels_offset = Pixel_size * pixer_nr;
	int rendered_vertex_offset = rendered_vertex_size * (screen_nr); // +26214 * Player[player_cycle]);
	*/



	// Get the index of the current element to be processed
	int i = get_global_id(0) / 1024;			// The vector
	int l = get_global_id(0) % 1024;


	//Rendered_Pixels[(l * 2) + Pixel_distance] = l;
	//Rendered_Pixels[(l * 2) + Pixel_item_nr] = 6;
	//return;




	int vector_ID = Renderd_Hits[i * 2];
	int vector_Field = Renderd_Hits[(i * 2) + 1];

	int hit_x = (vector_Field % 16) * 32;
	int hit_y = (vector_Field / 16) * 32;


	int local_hit_x = (l % 32) + hit_x;
	int local_hit_y = (l / 32) + hit_y;



	int rendered_Pixels_offset = Pixel_size* (local_hit_x + (512 * local_hit_y));
	int rendered_vertex_offset = rendered_vertex_size * vector_ID;




	temp_player_x = (( (float)( local_hit_x ) / screen_size_x) - (0.99 / 2)) * pov_x;
	temp_player_y = (( (float)( local_hit_y ) / screen_size_y) - (0.99 / 2)) * pov_y;




	float local_Rendered_Vertexes	[rendered_vertex_size];
	float local_Player				[player_size];

	for (int x = 0; x < rendered_vertex_size; x++) {
		local_Rendered_Vertexes[x] = Rendered_Vertexes[rendered_vertex_offset + x];
	}

	for (int x = 0; x < player_size; x++) {
		local_Player[x] = Player[x];
	}


	//temp_player_x = ((((pixer_nr) % screen_size_x) / screen_size_x) - (0.99/2)) * pov_x;
	//temp_player_y = ((((pixer_nr) / screen_size_x) / screen_size_y) - (0.99/2)) * pov_y;

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////


	d1 = (temp_player_x - local_Rendered_Vertexes[B_x]) * (local_Rendered_Vertexes[A_y] - local_Rendered_Vertexes[B_y]) - (local_Rendered_Vertexes[A_x] - local_Rendered_Vertexes[B_x]) * (temp_player_y - local_Rendered_Vertexes[B_y]);
	d2 = (temp_player_x - local_Rendered_Vertexes[C_x]) * (local_Rendered_Vertexes[B_y] - local_Rendered_Vertexes[C_y]) - (local_Rendered_Vertexes[B_x] - local_Rendered_Vertexes[C_x]) * (temp_player_y - local_Rendered_Vertexes[C_y]);
	d3 = (temp_player_x - local_Rendered_Vertexes[A_x]) * (local_Rendered_Vertexes[C_y] - local_Rendered_Vertexes[A_y]) - (local_Rendered_Vertexes[C_x] - local_Rendered_Vertexes[A_x]) * (temp_player_y - local_Rendered_Vertexes[A_y]);

	has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
	has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);




	if ((has_neg && has_pos)) {
		return;
	}
	

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////



	

	angle_x = sin(temp_player_x + local_Player[player_angle]);
	angle_y = cos(temp_player_x + local_Player[player_angle]);
	angle_z = sin(temp_player_y );	


	//mormalized
	float w = sqrt((angle_z * angle_z) + (angle_x * angle_x) + (angle_y * angle_y));
	angle_x /= w;
	angle_y /= w;
	angle_z /= w;



	
	float _angle = (angle_x * local_Rendered_Vertexes[r_norm_x] + angle_y * local_Rendered_Vertexes[r_norm_y]  + angle_z * local_Rendered_Vertexes[r_norm_z]);  //(angle, Norm);



	///////////////////////////////////////////////////////

	if (_angle == 0) {
		return;
	}

	float t;
	t = -((local_Rendered_Vertexes[d_origin]) / _angle);


	/////////////////////////////////////////////////////////

	///float p_temp_x = local_Player[player_x] + t * angle_x;
	///float p_temp_y = local_Player[player_y] + t * angle_y;
	///float p_temp_z = local_Player[player_z] + t * angle_z;


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
	Rendered_Pixels[rendered_Pixels_offset + Pixel_item_nr] = (vector_ID) + 1;

}
