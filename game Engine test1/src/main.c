#include "main.h"
#include <windows.h>
#include <time.h>

#include "GPU.h"

char buffer_array[270000] = { "X" };


void main() {






	screen_setup();


	//volatile clock_t start, stop;
	//volatile clock_t time_spend;
	//start = clock();
	//int counter = 0;

	while (1) {
		//Sleep(100);

		screen_run();

		/*
		counter++;
		if (counter > 100) {
			counter = 0;

			stop = clock();
			time_spend = stop - start;
			start = clock();

		}
		*/
	}




	for (int x = 0; x < 270000; x++) {
		buffer_array[x] = 'X';
	}
	int print_size = 270000;
	clock_t start_time = clock();

	for (int x = 0; x < 100; x++) {
		printf("%.*s", print_size, buffer_array);
		fflush(stdout);
	}

	clock_t end_time = clock();
	printf("\n\n %d \n\n", end_time - start_time);
	


	return 0;
}

