
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


__kernel void render_vertexes_kernel(__global const float* Vertexes, __global const float* Player, __global float* Rendered_Vertexes) {

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



    float x_diff;
    float y_diff;

    float ret_distance1;
    float z_diff;


    float d1, d2, d3;
    bool has_neg, has_pos;

    // Get the index of the current element to be processed
    int i = get_global_id(0);

    int vertex_offset = vertex_size * i;
    int renderd_vertex_offset = rendered_vertex_size * i;

    if( i >= Player[player_nr_faces]) {
        return;
    }






    Rendered_Vertexes[renderd_vertex_offset + a_x] = Vertexes[vertex_offset + a_x];
    Rendered_Vertexes[renderd_vertex_offset + a_y] = Vertexes[vertex_offset + a_y];
    Rendered_Vertexes[renderd_vertex_offset + a_z] = Vertexes[vertex_offset + a_z];

    Rendered_Vertexes[renderd_vertex_offset + b_x] = Vertexes[vertex_offset + b_x];
    Rendered_Vertexes[renderd_vertex_offset + b_y] = Vertexes[vertex_offset + b_y];
    Rendered_Vertexes[renderd_vertex_offset + b_z] = Vertexes[vertex_offset + b_z];

    Rendered_Vertexes[renderd_vertex_offset + c_x] = Vertexes[vertex_offset + c_x];
    Rendered_Vertexes[renderd_vertex_offset + c_y] = Vertexes[vertex_offset + c_y];
    Rendered_Vertexes[renderd_vertex_offset + c_z] = Vertexes[vertex_offset + c_z];

    Rendered_Vertexes[renderd_vertex_offset + offsett_x] = Vertexes[vertex_offset + offsett_x];
    Rendered_Vertexes[renderd_vertex_offset + offsett_y] = Vertexes[vertex_offset + offsett_y];
    Rendered_Vertexes[renderd_vertex_offset + offsett_z] = Vertexes[vertex_offset + offsett_z];

    Rendered_Vertexes[renderd_vertex_offset + norm_x] = Vertexes[vertex_offset + norm_x];
    Rendered_Vertexes[renderd_vertex_offset + norm_y] = Vertexes[vertex_offset + norm_y];
    Rendered_Vertexes[renderd_vertex_offset + norm_z] = Vertexes[vertex_offset + norm_z];







    Rendered_Vertexes[renderd_vertex_offset + look_away] = 0.0;

    // for A
    x_diff = Vertexes[vertex_offset + a_x] - Player[player_x];
    y_diff = Vertexes[vertex_offset + a_y] - Player[player_y];

    Rendered_Vertexes[renderd_vertex_offset + A_x] = atan2(x_diff, y_diff);
    Rendered_Vertexes[renderd_vertex_offset + A_x] -= Player[player_angle];

    while (Rendered_Vertexes[renderd_vertex_offset + A_x] > PI) {
        Rendered_Vertexes[renderd_vertex_offset + A_x] -= twoPI;
    }
    while (Rendered_Vertexes[renderd_vertex_offset + A_x] < -PI) {
        Rendered_Vertexes[renderd_vertex_offset + A_x] += twoPI;
    }


    ret_distance1 = sqrt((x_diff * x_diff) + (y_diff * y_diff));
    z_diff = Vertexes[vertex_offset + a_z] - Player[player_z];
    Rendered_Vertexes[renderd_vertex_offset + A_y] = atan2(z_diff, ret_distance1);



    // for B
    x_diff = Vertexes[vertex_offset + b_x] - Player[player_x];
    y_diff = Vertexes[vertex_offset + b_y] - Player[player_y];

    Rendered_Vertexes[renderd_vertex_offset + B_x] = atan2(x_diff, y_diff);
    Rendered_Vertexes[renderd_vertex_offset + B_x] -= Player[player_angle];

    while (Rendered_Vertexes[renderd_vertex_offset + B_x] > PI) {
        Rendered_Vertexes[renderd_vertex_offset + B_x] -= twoPI;
    }
    while (Rendered_Vertexes[renderd_vertex_offset + B_x] < -PI) {
        Rendered_Vertexes[renderd_vertex_offset + B_x] += twoPI;
    }

    ret_distance1 = sqrt((x_diff * x_diff) + (y_diff * y_diff));
    z_diff = Vertexes[vertex_offset + b_z] - Player[player_z];
    Rendered_Vertexes[renderd_vertex_offset + B_y] = atan2(z_diff, ret_distance1);



    // for C
    x_diff = Vertexes[vertex_offset + c_x] - Player[player_x];
    y_diff = Vertexes[vertex_offset + c_y] - Player[player_y];

    Rendered_Vertexes[renderd_vertex_offset + C_x] = atan2(x_diff, y_diff);
    Rendered_Vertexes[renderd_vertex_offset + C_x] -= Player[player_angle];

    while (Rendered_Vertexes[renderd_vertex_offset + C_x] > PI) {
        Rendered_Vertexes[renderd_vertex_offset + C_x] -= twoPI;
    }
    while (Rendered_Vertexes[renderd_vertex_offset + C_x] < -PI) {
        Rendered_Vertexes[renderd_vertex_offset + C_x] += twoPI;
    }

    ret_distance1 = sqrt((x_diff * x_diff) + (y_diff * y_diff));
    z_diff = Vertexes[vertex_offset + c_z] - Player[player_z];
    Rendered_Vertexes[renderd_vertex_offset + C_y] = atan2(z_diff, ret_distance1);


    // if two are in the same pixel, object is flat, aka skip
    Rendered_Vertexes[renderd_vertex_offset + look_away] += Rendered_Vertexes[renderd_vertex_offset + A_x] == Rendered_Vertexes[renderd_vertex_offset + B_x] & Rendered_Vertexes[renderd_vertex_offset + A_y] == Rendered_Vertexes[renderd_vertex_offset + B_y];
    Rendered_Vertexes[renderd_vertex_offset + look_away] += Rendered_Vertexes[renderd_vertex_offset + A_x] == Rendered_Vertexes[renderd_vertex_offset + C_x] & Rendered_Vertexes[renderd_vertex_offset + A_y] == Rendered_Vertexes[renderd_vertex_offset + C_y];
    Rendered_Vertexes[renderd_vertex_offset + look_away] += Rendered_Vertexes[renderd_vertex_offset + C_x] == Rendered_Vertexes[renderd_vertex_offset + B_x] & Rendered_Vertexes[renderd_vertex_offset + C_y] == Rendered_Vertexes[renderd_vertex_offset + B_y];

    if (Rendered_Vertexes[renderd_vertex_offset + look_away] > 0){
        Rendered_Vertexes[renderd_vertex_offset + look_away] = 11;
        return;
  
    }


        ////////////////////////////////////////////////////////



    d1 = (Player[player_x] - Vertexes[vertex_offset + b_x]) * (Vertexes[vertex_offset + a_y] - Vertexes[vertex_offset + b_y]) - (Vertexes[vertex_offset + a_x] - Vertexes[vertex_offset + b_x]) * (Player[player_y] - Vertexes[vertex_offset + b_y]);
    d2 = (Player[player_x] - Vertexes[vertex_offset + c_x]) * (Vertexes[vertex_offset + b_y] - Vertexes[vertex_offset + c_y]) - (Vertexes[vertex_offset + b_x] - Vertexes[vertex_offset + c_x]) * (Player[player_y] - Vertexes[vertex_offset + c_y]);
    d3 = (Player[player_x] - Vertexes[vertex_offset + a_x]) * (Vertexes[vertex_offset + c_y] - Vertexes[vertex_offset + a_y]) - (Vertexes[vertex_offset + c_x] - Vertexes[vertex_offset + a_x]) * (Player[player_y] - Vertexes[vertex_offset + a_y]);

    has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    
    if ((has_neg && has_pos))
    {
        //check if the angles crosses the - and + Pi line

        if ((fabs(Rendered_Vertexes[renderd_vertex_offset + A_x] - Rendered_Vertexes[renderd_vertex_offset + B_x]) > PI  ) ||
            (fabs(Rendered_Vertexes[renderd_vertex_offset + A_x] - Rendered_Vertexes[renderd_vertex_offset + C_x]) > PI  ) ||
            (fabs(Rendered_Vertexes[renderd_vertex_offset + B_x] - Rendered_Vertexes[renderd_vertex_offset + C_x]) > PI ))
        {



            //Check closest to middle of screen.
            //A Closest
            if (fabs(Rendered_Vertexes[renderd_vertex_offset + A_x]) <= fabs(Rendered_Vertexes[renderd_vertex_offset + B_x]) && fabs(Rendered_Vertexes[renderd_vertex_offset + A_x]) <= fabs(Rendered_Vertexes[renderd_vertex_offset + C_x]))
            {


                if (Rendered_Vertexes[renderd_vertex_offset + A_x] >= 0 && Rendered_Vertexes[renderd_vertex_offset + B_x] < 0) {
                    Rendered_Vertexes[renderd_vertex_offset + B_x] += twoPI;
                }

                if (Rendered_Vertexes[renderd_vertex_offset + A_x] <= 0 && Rendered_Vertexes[renderd_vertex_offset + B_x] > 0) {
                    Rendered_Vertexes[renderd_vertex_offset + B_x] -= twoPI;
                }


                if (Rendered_Vertexes[renderd_vertex_offset + A_x] >= 0 && Rendered_Vertexes[renderd_vertex_offset + C_x] < 0) {
                    Rendered_Vertexes[renderd_vertex_offset + C_x] += twoPI;
                }

                if (Rendered_Vertexes[renderd_vertex_offset + A_x] <= 0 && Rendered_Vertexes[renderd_vertex_offset + C_x] > 0) {
                    Rendered_Vertexes[renderd_vertex_offset + C_x] -= twoPI;
                }


            }
            //B closest
            else if (fabs(Rendered_Vertexes[renderd_vertex_offset + B_x]) <= fabs(Rendered_Vertexes[renderd_vertex_offset + C_x])) {


                if (Rendered_Vertexes[renderd_vertex_offset + B_x] >= 0 && Rendered_Vertexes[renderd_vertex_offset + A_x] < 0) {
                    Rendered_Vertexes[renderd_vertex_offset + A_x] += twoPI;
                }

                if (Rendered_Vertexes[renderd_vertex_offset + B_x] <= 0 && Rendered_Vertexes[renderd_vertex_offset + A_x] > 0) {
                    Rendered_Vertexes[renderd_vertex_offset + A_x] -= twoPI;
                }


                if (Rendered_Vertexes[renderd_vertex_offset + B_x] >= 0 && Rendered_Vertexes[renderd_vertex_offset + C_x] < 0) {
                    Rendered_Vertexes[renderd_vertex_offset + C_x] += twoPI;
                }

                if (Rendered_Vertexes[renderd_vertex_offset + B_x] <= 0 && Rendered_Vertexes[renderd_vertex_offset + C_x] > 0) {
                    Rendered_Vertexes[renderd_vertex_offset + C_x] -= twoPI;
                }


            }
            //C closest
            else {



                if (Rendered_Vertexes[renderd_vertex_offset + C_x] >= 0 && Rendered_Vertexes[renderd_vertex_offset + B_x] < 0) {
                    Rendered_Vertexes[renderd_vertex_offset + B_x] += twoPI;
                }

                if (Rendered_Vertexes[renderd_vertex_offset + C_x] <= 0 && Rendered_Vertexes[renderd_vertex_offset + B_x] > 0) {
                    Rendered_Vertexes[renderd_vertex_offset + B_x] -= twoPI;
                }


                if (Rendered_Vertexes[renderd_vertex_offset + C_x] >= 0 && Rendered_Vertexes[renderd_vertex_offset + A_x] < 0) {
                    Rendered_Vertexes[renderd_vertex_offset + A_x] += twoPI;
                }

                if (Rendered_Vertexes[renderd_vertex_offset + C_x] <= 0 && Rendered_Vertexes[renderd_vertex_offset + A_x] > 0) {
                    Rendered_Vertexes[renderd_vertex_offset + A_x] -= twoPI;
                }


            }



        }
    }
    else
    {
        ////
    }
    

    return;

    ////////////////////////////////////////////////////////

        // Calc slobes for point A


    diff_ab_x = Rendered_Vertexes[renderd_vertex_offset + B_x] - Rendered_Vertexes[renderd_vertex_offset + A_x];
    diff_ab_y = Rendered_Vertexes[renderd_vertex_offset + B_y] - Rendered_Vertexes[renderd_vertex_offset + A_y];
    diff_ac_x = Rendered_Vertexes[renderd_vertex_offset + C_x] - Rendered_Vertexes[renderd_vertex_offset + A_x];
    diff_ac_y = Rendered_Vertexes[renderd_vertex_offset + C_y] - Rendered_Vertexes[renderd_vertex_offset + A_y];

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
        Rendered_Vertexes[renderd_vertex_offset + look_away] += diff_ab_x == diff_ac_x;
        if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
            Rendered_Vertexes[renderd_vertex_offset + look_away] = 12;
            return;
        }


        if (diff_ab_x == 0) {

            //kijkt weg

            Rendered_Vertexes[renderd_vertex_offset + look_away] += (diff_ac_x > 0) & (diff_ab_y >= 0);
            if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
                Rendered_Vertexes[renderd_vertex_offset + look_away] = 13;
                return;
            }

            Rendered_Vertexes[renderd_vertex_offset + look_away] += (diff_ac_x < 0) & (diff_ab_y < 0);
            if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
                Rendered_Vertexes[renderd_vertex_offset + look_away] = 14;
                return;
            }



        }
        if (diff_ac_x == 0) {

            //kijkt weg

            Rendered_Vertexes[renderd_vertex_offset + look_away] += (diff_ab_x < 0) & (diff_ac_y >= 0);
            if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
                Rendered_Vertexes[renderd_vertex_offset + look_away] = 15;
                return;
            }

            Rendered_Vertexes[renderd_vertex_offset + look_away] += (diff_ab_x > 0) & (diff_ac_y < 0);
            if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
                Rendered_Vertexes[renderd_vertex_offset + look_away] = 16;
                return;
            }

        }






    }
    else
    {







        // Looking away, object is flat, aka skip
        if ((diff_ab_x * diff_ac_x) >= 0) { // iff both the same quadrant/half

            // all on the same line, object is flat, aka skip
            Rendered_Vertexes[renderd_vertex_offset + look_away] += slobe_ab == slobe_ac;
            if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
                Rendered_Vertexes[renderd_vertex_offset + look_away] = 17;
                return;
            }


            //kijkt weg
            Rendered_Vertexes[renderd_vertex_offset + look_away] += slobe_ab > slobe_ac;
            if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
                Rendered_Vertexes[renderd_vertex_offset + look_away] = 18;
                return;
            }
        }
        else { /// iff differ quadrant

            //kijkt weg
            Rendered_Vertexes[renderd_vertex_offset + look_away] += (slobe_ab < slobe_ac);
            if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
                Rendered_Vertexes[renderd_vertex_offset + look_away] = 19;
                return;
            }
        }


    }









    // Calc slobes for point B
    diff_bc_x = Rendered_Vertexes[renderd_vertex_offset + C_x] - Rendered_Vertexes[renderd_vertex_offset + B_x];
    diff_bc_y = Rendered_Vertexes[renderd_vertex_offset + C_y] - Rendered_Vertexes[renderd_vertex_offset + B_y];
    diff_ba_x = Rendered_Vertexes[renderd_vertex_offset + A_x] - Rendered_Vertexes[renderd_vertex_offset + B_x];
    diff_ba_y = Rendered_Vertexes[renderd_vertex_offset + A_y] - Rendered_Vertexes[renderd_vertex_offset + B_y];




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
        Rendered_Vertexes[renderd_vertex_offset + look_away] += slobe_bc == slobe_ba;
        if (Rendered_Vertexes[renderd_vertex_offset + look_away]) {
            Rendered_Vertexes[renderd_vertex_offset + look_away] = 20;
            return;
        }
    }






}