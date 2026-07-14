
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


#define screen_size_x 512
#define screen_size_y 160
#define screen_buffer_size  81920		//512 * 160

#define process_block_size 32

#define pov_x  1.570796327
#define pov_y  0.7853981635


__kernel void render_vertexes_kernel(__global const float* Vertexes, __global float* Player, __global int* Hit_Buffers, __global float* Rendered_Vertexes) {

    float diff_ab_x;
    float diff_ab_y;
    float diff_ac_x;
    float diff_ac_y;

    float diff_bc_x;
    float diff_bc_y;
    float diff_ba_x;
    float diff_ba_y;

    float slobe_ab;
    float slobe_ac;
    float slobe_bc;
    float slobe_ba;

    bool slobe_ab_check;
    bool slobe_ac_check;
    bool slobe_bc_check;
    bool slobe_ba_check;

    float look_away;

    float x_diff;
    float y_diff;

    float ret_distance1;
    float z_diff;


    float d1, d2, d3;
    bool has_neg, has_pos;

    float local_Vertexes[vertex_size];
    float local_Rendered_Vertexes[rendered_vertex_size];


    // Get the index of the current element to be processed
    //size_t  i = get_global_id(0) / 1024;      ///1024 and * 1024 is for rounding down
    //size_t  l = get_global_id(0) % 1024;

    size_t  vertex_offset_size = get_global_id(0);

    int vertex_offset = vertex_size * vertex_offset_size;



    //int rendered_offset_size = Count_Buffers[l] * 1024 + l;
   // Count_Buffers[l + 1024] += 1;;//hit;
   // Count_Buffers[l] = l;



    if (vertex_offset_size >= Player[player_nr_faces]) {
        return;
    }


    //if (get_global_id(0) == 3) {
        //Count_Buffers[3] = 3;
    //}

    //if (get_global_id(0) == 24) {
        //Count_Buffers[0] = 4;
    //}





    for (int x = 0; x < vertex_size; x++) {
        local_Vertexes[x] = Vertexes[vertex_offset + x];
    }



  ///  local_Rendered_Vertexes[a_x] = local_Vertexes[a_x];
   /// local_Rendered_Vertexes[a_y] = local_Vertexes[a_y];
  ///  local_Rendered_Vertexes[a_z] = local_Vertexes[a_z];







   // local_Rendered_Vertexes[b_x] = local_Vertexes[b_x];
   // local_Rendered_Vertexes[b_y] = local_Vertexes[b_y];
   // local_Rendered_Vertexes[b_z] = local_Vertexes[b_z];

   // local_Rendered_Vertexes[c_x] = local_Vertexes[c_x];
   // local_Rendered_Vertexes[c_y] = local_Vertexes[c_y];
   // local_Rendered_Vertexes[c_z] = local_Vertexes[c_z];

   // local_Rendered_Vertexes[offsett_x] = local_Vertexes[offsett_x];
   // local_Rendered_Vertexes[offsett_y] = local_Vertexes[offsett_y];
    //local_Rendered_Vertexes[offsett_z] = local_Vertexes[offsett_z];





    local_Rendered_Vertexes[d_origin] = (- (local_Vertexes[norm_x] * local_Vertexes[a_x] + local_Vertexes[norm_y] * local_Vertexes[a_y] + local_Vertexes[norm_z] * local_Vertexes[a_z]) )  +
                                                            ((Player[player_x] * local_Vertexes[norm_x] + Player[player_y] * local_Vertexes[norm_y] + Player[player_z] * local_Vertexes[norm_z]) );                 //(Norm, a);  //(player_coordinates, Norm);








    look_away = 0.0;

    // for A
    x_diff = local_Vertexes[a_x] - Player[player_x];
    y_diff = local_Vertexes[a_y] - Player[player_y];

    local_Rendered_Vertexes[A_x] = atan2(x_diff, y_diff);
    local_Rendered_Vertexes[A_x] -= Player[player_angle];

    while (local_Rendered_Vertexes[A_x] > PI) {
        local_Rendered_Vertexes[A_x] -= twoPI;
    }
    while (local_Rendered_Vertexes[A_x] < -PI) {
        local_Rendered_Vertexes[A_x] += twoPI;
    }


    ret_distance1 = sqrt((x_diff * x_diff) + (y_diff * y_diff));
    z_diff = local_Vertexes[a_z] - Player[player_z];
    local_Rendered_Vertexes[A_y] = atan2(z_diff, ret_distance1);



    // for B
    x_diff = local_Vertexes[b_x] - Player[player_x];
    y_diff = local_Vertexes[b_y] - Player[player_y];

    local_Rendered_Vertexes[B_x] = atan2(x_diff, y_diff);
    local_Rendered_Vertexes[B_x] -= Player[player_angle];

    while (local_Rendered_Vertexes[B_x] > PI) {
        local_Rendered_Vertexes[B_x] -= twoPI;
    }
    while (local_Rendered_Vertexes[B_x] < -PI) {
        local_Rendered_Vertexes[B_x] += twoPI;
    }

    ret_distance1 = sqrt((x_diff * x_diff) + (y_diff * y_diff));
    z_diff = local_Vertexes[b_z] - Player[player_z];
    local_Rendered_Vertexes[B_y] = atan2(z_diff, ret_distance1);



    // for C
    x_diff = local_Vertexes[c_x] - Player[player_x];
    y_diff = local_Vertexes[c_y] - Player[player_y];

    local_Rendered_Vertexes[C_x] = atan2(x_diff, y_diff);
    local_Rendered_Vertexes[C_x] -= Player[player_angle];

    while (local_Rendered_Vertexes[C_x] > PI) {
        local_Rendered_Vertexes[C_x] -= twoPI;
    }
    while (local_Rendered_Vertexes[C_x] < -PI) {
        local_Rendered_Vertexes[C_x] += twoPI;
    }

    ret_distance1 = sqrt((x_diff * x_diff) + (y_diff * y_diff));
    z_diff = local_Vertexes[c_z] - Player[player_z];
    local_Rendered_Vertexes[C_y] = atan2(z_diff, ret_distance1);


    // if two are in the same pixel, object is flat, aka skip
    look_away += local_Rendered_Vertexes[A_x] == local_Rendered_Vertexes[B_x] & local_Rendered_Vertexes[A_y] == local_Rendered_Vertexes[B_y];
    look_away += local_Rendered_Vertexes[A_x] == local_Rendered_Vertexes[C_x] & local_Rendered_Vertexes[A_y] == local_Rendered_Vertexes[C_y];
    look_away += local_Rendered_Vertexes[C_x] == local_Rendered_Vertexes[B_x] & local_Rendered_Vertexes[C_y] == local_Rendered_Vertexes[B_y];

    if (look_away > 0){
        look_away = 11;
        return;
  
    }




        ////////////////////////////////////////////////////////



    d1 = (Player[player_x] - local_Vertexes[b_x]) * (local_Vertexes[a_y] - local_Vertexes[b_y]) - (local_Vertexes[a_x] - local_Vertexes[b_x]) * (Player[player_y] - local_Vertexes[b_y]);
    d2 = (Player[player_x] - local_Vertexes[c_x]) * (local_Vertexes[b_y] - local_Vertexes[c_y]) - (local_Vertexes[b_x] - local_Vertexes[c_x]) * (Player[player_y] - local_Vertexes[c_y]);
    d3 = (Player[player_x] - local_Vertexes[a_x]) * (local_Vertexes[c_y] - local_Vertexes[a_y]) - (local_Vertexes[c_x] - local_Vertexes[a_x]) * (Player[player_y] - local_Vertexes[a_y]);

    has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    
    if ((has_neg && has_pos))
    {
        //check if the angles crosses the - and + Pi line

        if ((fabs(local_Rendered_Vertexes[A_x] - local_Rendered_Vertexes[B_x]) > PI  ) ||
            (fabs(local_Rendered_Vertexes[A_x] - local_Rendered_Vertexes[C_x]) > PI  ) ||
            (fabs(local_Rendered_Vertexes[B_x] - local_Rendered_Vertexes[C_x]) > PI ))
        {



            //Check closest to middle of screen.
            //A Closest
            if (fabs(local_Rendered_Vertexes[A_x]) <= fabs(local_Rendered_Vertexes[B_x]) && fabs(local_Rendered_Vertexes[A_x]) <= fabs(local_Rendered_Vertexes[C_x]))
            {


                if (local_Rendered_Vertexes[A_x] >= 0 && local_Rendered_Vertexes[B_x] < 0) {
                    local_Rendered_Vertexes[B_x] += twoPI;
                }

                if (local_Rendered_Vertexes[A_x] <= 0 && local_Rendered_Vertexes[B_x] > 0) {
                    local_Rendered_Vertexes[B_x] -= twoPI;
                }


                if (local_Rendered_Vertexes[A_x] >= 0 && local_Rendered_Vertexes[C_x] < 0) {
                    local_Rendered_Vertexes[C_x] += twoPI;
                }

                if (local_Rendered_Vertexes[A_x] <= 0 && local_Rendered_Vertexes[C_x] > 0) {
                    local_Rendered_Vertexes[C_x] -= twoPI;
                }


            }
            //B closest
            else if (fabs(local_Rendered_Vertexes[B_x]) <= fabs(local_Rendered_Vertexes[C_x])) {


                if (local_Rendered_Vertexes[B_x] >= 0 && local_Rendered_Vertexes[A_x] < 0) {
                    local_Rendered_Vertexes[A_x] += twoPI;
                }

                if (local_Rendered_Vertexes[B_x] <= 0 && local_Rendered_Vertexes[A_x] > 0) {
                    local_Rendered_Vertexes[A_x] -= twoPI;
                }


                if (local_Rendered_Vertexes[B_x] >= 0 && local_Rendered_Vertexes[C_x] < 0) {
                    local_Rendered_Vertexes[C_x] += twoPI;
                }

                if (local_Rendered_Vertexes[B_x] <= 0 && local_Rendered_Vertexes[C_x] > 0) {
                    local_Rendered_Vertexes[C_x] -= twoPI;
                }


            }
            //C closest
            else {



                if (local_Rendered_Vertexes[C_x] >= 0 && local_Rendered_Vertexes[B_x] < 0) {
                    local_Rendered_Vertexes[B_x] += twoPI;
                }

                if (local_Rendered_Vertexes[C_x] <= 0 && local_Rendered_Vertexes[B_x] > 0) {
                    local_Rendered_Vertexes[B_x] -= twoPI;
                }


                if (local_Rendered_Vertexes[C_x] >= 0 && local_Rendered_Vertexes[A_x] < 0) {
                    local_Rendered_Vertexes[A_x] += twoPI;
                }

                if (local_Rendered_Vertexes[C_x] <= 0 && local_Rendered_Vertexes[A_x] > 0) {
                    local_Rendered_Vertexes[A_x] -= twoPI;
                }


            }



        }
    }
    

    ////////////////////////////////////////////////////////

        // Calc slobes for point A


    diff_ab_x = local_Rendered_Vertexes[B_x] - local_Rendered_Vertexes[A_x];
    diff_ab_y = local_Rendered_Vertexes[B_y] - local_Rendered_Vertexes[A_y];
    diff_ac_x = local_Rendered_Vertexes[C_x] - local_Rendered_Vertexes[A_x];
    diff_ac_y = local_Rendered_Vertexes[C_y] - local_Rendered_Vertexes[A_y];

    if (diff_ab_x == 0) {
        slobe_ab_check = true;
    }
    else {
        slobe_ab_check = false;
        slobe_ab = diff_ab_y / diff_ab_x;
    }



    if (diff_ac_x == 0) {
        slobe_ac_check = true;
    }
    else {
        slobe_ac_check = false;
        slobe_ac = diff_ac_y / diff_ac_x;
    }







    if (diff_ab_x == 0 | diff_ac_x == 0) {



        //on the same line
        look_away += diff_ab_x == diff_ac_x;
        if (look_away) {
            look_away = 12;
            return;
        }


        if (diff_ab_x == 0) {

            //kijkt weg

            look_away += (diff_ac_x > 0) & (diff_ab_y >= 0);
            if (look_away) {
                look_away = 13;
                return;
            }

            look_away += (diff_ac_x < 0) & (diff_ab_y < 0);
            if (look_away) {
                look_away = 14;
                return;
            }



        }
        if (diff_ac_x == 0) {

            //kijkt weg

            look_away += (diff_ab_x < 0) & (diff_ac_y >= 0);
            if (look_away) {
                look_away = 15;
                return;
            }

            look_away += (diff_ab_x > 0) & (diff_ac_y < 0);
            if (look_away) {
                look_away = 16;
                return;
            }

        }






    }
    else
    {







        // Looking away, object is flat, aka skip
        if ((diff_ab_x * diff_ac_x) >= 0) { // iff both the same quadrant/half

            // all on the same line, object is flat, aka skip
            look_away += slobe_ab == slobe_ac;
            if (look_away) {
                look_away = 17;
                return;
            }


            //kijkt weg
            look_away += slobe_ab > slobe_ac;
            if (look_away) {
                look_away = 18;
                return;
            }
        }
        else { /// iff differ quadrant

            //kijkt weg
            look_away += (slobe_ab < slobe_ac);
            if (look_away) {
                look_away = 19;
                return;
            }
        }


    }









    // Calc slobes for point B
    diff_bc_x = local_Rendered_Vertexes[C_x] - local_Rendered_Vertexes[B_x];
    diff_bc_y = local_Rendered_Vertexes[C_y] - local_Rendered_Vertexes[B_y];
    diff_ba_x = local_Rendered_Vertexes[A_x] - local_Rendered_Vertexes[B_x];
    diff_ba_y = local_Rendered_Vertexes[A_y] - local_Rendered_Vertexes[B_y];




    if (diff_bc_x == 0) {
        slobe_bc_check = true;
    }
    else {
        slobe_bc_check = false;
        slobe_bc = diff_bc_y / diff_bc_x;
    }



    if (diff_ba_x == 0) {
        slobe_ba_check = true;
    }
    else {
        slobe_ba_check = false;
        slobe_ba = diff_ba_y / diff_ba_x;
    }


    if ((diff_ba_x * diff_bc_x) >= 0) { // iff both the same quadrant
        // all on the same line, object is flat, aka skip
        look_away += slobe_bc == slobe_ba;
        if (look_away) {
            look_away = 20;
            return;
        }
    }





    //Count_Buffers[6] = 6;


    //Rendered_Vertexes[renderd_vertex_offset + r_norm_x] = local_Vertexes[norm_x];
    //Rendered_Vertexes[renderd_vertex_offset + r_norm_y] = local_Vertexes[norm_y];
    //Rendered_Vertexes[renderd_vertex_offset + r_norm_z] = local_Vertexes[norm_z];

    local_Rendered_Vertexes[r_norm_x] = local_Vertexes[norm_x];
    local_Rendered_Vertexes[r_norm_y] = local_Vertexes[norm_y];
    local_Rendered_Vertexes[r_norm_z] = local_Vertexes[norm_z];


    float x_max, x_min;
    float y_max, y_min;

    int player_x_max_blok, player_y_max_blok;
    int player_x_min_blok, player_y_min_blok;

    float pixel_block_size_x = pov_x / (screen_size_x / process_block_size);
    float pixel_block_size_y = pov_y / ((screen_size_y / process_block_size) * 2); // 10 y size calcs

    x_max = fmax(local_Rendered_Vertexes[A_x], local_Rendered_Vertexes[B_x]);
    x_max = fmax(x_max, local_Rendered_Vertexes[C_x]);

    y_max = fmax(local_Rendered_Vertexes[A_y], local_Rendered_Vertexes[B_y]);
    y_max = fmax(y_max, local_Rendered_Vertexes[C_y]);



    x_min = fmin(local_Rendered_Vertexes[A_x], local_Rendered_Vertexes[B_x]);
    x_min = fmin(x_min, local_Rendered_Vertexes[C_x]);

    y_min = fmin(local_Rendered_Vertexes[A_y], local_Rendered_Vertexes[B_y]);
    y_min = fmin(y_min, local_Rendered_Vertexes[C_y]);



    //Transform to blocks
    x_max /= pixel_block_size_x;
    x_min /= pixel_block_size_x;
    y_max /= pixel_block_size_y;
    y_min /= pixel_block_size_y;

    //round up or down into blocks
    int intx_max = x_max;// +(x_max > 0);
    int intx_min = x_min;// + (x_min < 0);

    int inty_max = y_max;// + (y_max > 0);
    int inty_min = y_min;// + (y_min < 0);


    intx_max += (x_max > 0);
    intx_min -= (x_min < 0);

    inty_max += (y_max > 0);
    inty_min -= (y_min < 0);


    player_x_max_blok = (screen_size_x / process_block_size) / 2;
    player_y_max_blok = (screen_size_y / process_block_size);

    player_x_min_blok = -(screen_size_x / process_block_size) / 2;
    player_y_min_blok = -(screen_size_y / process_block_size);

    if (intx_max < player_x_min_blok || inty_max < player_y_min_blok || intx_min > player_x_max_blok || inty_min > player_y_max_blok) {
        return;
    }   //offscreen

    //move all above up in the code after the 2d generating

    int full_buffer = 0xFFFF;
    int temp_buffer_x;
    int temp_buffer_y;
    int temp_hit_buffer[5];


    //Slim down the Vertex area till only the screen area

    intx_max = min(intx_max, player_x_max_blok);
    intx_min = max(intx_min, player_x_min_blok);

    inty_max = min(inty_max, player_y_max_blok);
    inty_min = max(inty_min, player_y_min_blok);

    //temp_buffer_x = full_buffer >> (16 - (intx_max - intx_min));
    //temp_buffer_x <<= (intx_min + 8);

    //temp_buffer_y = full_buffer >> (16 - (inty_max - inty_min));
   // temp_buffer_y <<= (inty_min + 5);



    //for (int y = 0; y < 5; y++) {

       // (temp_buffer_y & (1 << y))


   //     temp_hit_buffer[y] = get_global_id(0);// temp_buffer_x;// *((temp_buffer_y & (1 << (y * 2))) || (temp_buffer_y & (1 << ((y * 2) + 1))));

    //}


    intx_max += 8;
    intx_min += 8;

    inty_max += 5;
    inty_min += 5;




    inty_max = (inty_max / 2) + (inty_max % 2);
    inty_min /= 2;



    int hit = (intx_max - intx_min) * (inty_max - inty_min);

    temp_hit_buffer[0] = intx_min;
    temp_hit_buffer[1] = intx_max;

    temp_hit_buffer[2] = inty_min;
    temp_hit_buffer[3] = inty_max;

    temp_hit_buffer[4] = hit;

    if (hit <= 0) {
        return;
    }






    int rendered_vertex_offset = rendered_vertex_size * get_global_id(0);


    for (int y = 0; y < 5; y++) {
        Hit_Buffers[(get_global_id(0) * 5) + y] = temp_hit_buffer[y];
    }

    for (int x = 0; x < rendered_vertex_size; x++) {
        Rendered_Vertexes[rendered_vertex_offset + x] = local_Rendered_Vertexes[x];
    }

}