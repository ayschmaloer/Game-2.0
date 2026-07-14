#include "lookup_tables.h"
#include "calculations.h"




float atan_table[36000];




void create_lookup_tables(int size, int x) {

}

float get_atan(float angle) {

	//atanf();
}

float calc_atan(float x, float y) {
	float result = atan(x / y);

	if (x < 0) {
		if (y < 0) {
			result -= PI;
		}
		else
		{
			result += PI;
		}
	}

	result = atan2f(x, y);

	return result;
}