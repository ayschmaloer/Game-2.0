#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>

#include "CL/opencl.h"
#include <CL/cl.h>
#include "GPU.h"
#include <time.h>


#define screen_size_x 16*32
#define screen_size_y 5*32

#define MAX_SOURCE_SIZE (0x100000)


int counter = 0;
volatile clock_t start, stop;
volatile clock_t time_spend;
volatile clock_t time_tot;




void gpu_init();

void gpu_build_kernel_program(const char* file_name, const char* kernel_name, cl_program* program, cl_kernel* kernel);

void gpu_setup_buffers(int nr_faces);
void gpu_setup_kernel_arguments();

void gpu_setup_kernel_programs(cl_program program);

void gpu_read_vertexes(int nr_faces);

int* A;
int* B;
int* C;

cl_device_id device;
cl_context context;


// Create memory buffers on the device for each vector 
cl_mem vertex_mem_obj;
cl_mem player_mem_obj;
cl_mem buff_counter_mem_obj;
cl_mem hits_mem_obj;
cl_mem rendered_mem_obj;
cl_mem pixel_mem_obj;

cl_kernel kernel1;
cl_kernel kernel2;
volatile cl_command_queue command_queue_copy;


cl_program program1;
cl_program program2;


typedef struct {
	char* strName;

}GPU_Object;

void test_gpu_init(int nr_faces) {

	gpu_init();

	gpu_setup_buffers(nr_faces);


	test_gpu_reinit(nr_faces);


	return;


}

void test_gpu_reinit(int nr_faces) {



	gpu_build_kernel_program("render_vertexes_kernel.cl", "render_vertexes_kernel", &program1, &kernel1);
	gpu_build_kernel_program("render_pixels_kernel.cl", "render_pixels_kernel", &program2, &kernel2);
	
	printf("build kernels\n");
	gpu_setup_kernel_arguments();

	printf("build done\n");
	volatile int rr = 0;
	printf("Finished\n");

}


void gpu_write_vextors(int nr_faces, Vertex* vertex_array) {
	start = clock();
	cl_int QueueWriteResult;
	QueueWriteResult = clEnqueueWriteBuffer(command_queue_copy, vertex_mem_obj, CL_TRUE, 0,
		nr_faces * sizeof(Vertex), (float*)vertex_array, 0, NULL, NULL);
	//printf("ret at %d is %d\n", __LINE__, QueueWriteResult);

	clFinish(command_queue_copy);

	stop = clock();
	time_tot = stop - start;
}





void gpu_write_player_data(Player_coordinates* player_data) {
	cl_int QueueWriteResult;
	QueueWriteResult = clEnqueueWriteBuffer(command_queue_copy, player_mem_obj, CL_TRUE, 0,
		sizeof(Player_coordinates), (float*)player_data, 0, NULL, NULL);
	//printf("ret at %d is %d\n", __LINE__, QueueWriteResult);
	clFinish(command_queue_copy);
}







void gpu_execute_program1(int nr_faces) 
{
	int global_vertex_size = ((nr_faces / 1024) + 1) * 1024;

	int pattern = 0;
	size_t pattern_size = 1;
	cl_int result = clEnqueueFillBuffer(command_queue_copy, buff_counter_mem_obj, &pattern, pattern_size, 0, (global_vertex_size * sizeof(int) * 5), 0, NULL, NULL);
	clFinish(command_queue_copy);


	int global_size = nr_faces / 1024;
	size_t global_item_size = (global_size + 1) * 1024; // Process the entire lists
	size_t local_item_size = 1024; // Divide work items into groups of 64

	cl_int NDRangeKernelResult;
	NDRangeKernelResult = clEnqueueNDRangeKernel(command_queue_copy, kernel1, 1, NULL, &global_item_size, &local_item_size, 0, NULL, NULL);
	printf("ret at %d is %d\n", __LINE__, NDRangeKernelResult);
	clFinish(command_queue_copy);


}

void gpu_read_vertex_data(int* Hits_buffer_counters, int nr_faces) {
	int global_vertex_size = ((nr_faces / 1024) + 1) * 1024;

	//Fill the mem buffers
	cl_int QueueReadResult;

	QueueReadResult = clEnqueueReadBuffer(command_queue_copy, buff_counter_mem_obj, CL_TRUE, 0,
		(global_vertex_size * sizeof(int) * 5), (int*)Hits_buffer_counters, 0, NULL, NULL);
	printf("ret at %d is %d\n", __LINE__, QueueReadResult);

	clFinish(command_queue_copy);


}




void gpu_write_renderd_hits_data(int* Rendered_Vector_Hits, int write_size) {
	cl_int QueueWriteResult;

	QueueWriteResult = clEnqueueWriteBuffer(command_queue_copy, hits_mem_obj, CL_TRUE, 0,
		write_size * 2 * sizeof(int), (float*)Rendered_Vector_Hits, 0, NULL, NULL);
	//printf("ret at %d is %d\n", __LINE__, QueueWriteResult);
	clFinish(command_queue_copy);

}



void gpu_execute_program2(int nr_hits, Player_coordinates* player_data) {


	volatile clock_t start, stop;
	volatile clock_t time_spend;
	start = clock();



	cl_int NDRangeKernelResult;
	int cycle = 0;
	int pattern = 0;
	size_t pattern_size = 1;
	cl_int result = clEnqueueFillBuffer(command_queue_copy, pixel_mem_obj, &pattern, pattern_size, 0, screen_size_x * screen_size_y * sizeof(Pixel), 0, NULL, NULL);
	clFinish(command_queue_copy);

	size_t max_item_size;

	// ((0x7fffffff / 1024) * 1024);  //max nr of vexers per clEnqueueNDRangeKernel(); 
	max_item_size = ((0x7fffffff / 1024) * 1024);


	size_t global_item_size = (size_t)nr_hits * 1024; // Process the entire lists
	size_t local_item_size = 1024; // Divide work items into groups of 64


	
	while (global_item_size > max_item_size) {

		while (1) printf("Error\n");


		/*
		NDRangeKernelResult = clEnqueueNDRangeKernel(command_queue_copy, kernel2, 1, NULL, &max_item_size, &local_item_size, 0, NULL, NULL);
		//printf("ret at %d is %d\n", __LINE__, NDRangeKernelResult);
		clFinish(command_queue_copy);

		cycle++;
		global_item_size -= max_item_size;

		player_data->cycle = cycle;
		gpu_write_player_data(player_data);
		*/


	}


	NDRangeKernelResult = clEnqueueNDRangeKernel(command_queue_copy, kernel2, 1, NULL, &global_item_size, &local_item_size, 0, NULL, NULL);
	printf("ret at %d is %d\n", __LINE__, NDRangeKernelResult);

	clFinish(command_queue_copy);

	counter++;
	stop = clock();
	time_tot += stop - start;


	if (counter > 10) {
		counter = 0;

		time_tot = 0;

	}
}

void gpu_read_pixels(Pixel* pixel_array) {

	//Fill the mem buffers
	cl_int QueueReadResult;
	// Copy the lists A and B to their respective memory buffers
	QueueReadResult = clEnqueueReadBuffer(command_queue_copy, pixel_mem_obj, CL_TRUE, 0,
		screen_size_x * screen_size_y * sizeof(Pixel), pixel_array, 0, NULL, NULL);
	printf("ret at %d is %d\n", __LINE__, QueueReadResult);

	clFinish(command_queue_copy);


}
 





void gpu_setup_buffers(int nr_faces) {

	int global_vertex_size = ((nr_faces / 1024) + 1 ) * 1024;

	// Create memory buffers on the device for each vector 
	cl_int bufferResult;

	//vertex buffer
	vertex_mem_obj = clCreateBuffer(context, CL_MEM_READ_WRITE, global_vertex_size * sizeof(Vertex), NULL, &bufferResult);
	printf("ret at %d is %d\n", __LINE__, bufferResult);

	//player buffer
	player_mem_obj = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(Player_coordinates), NULL, &bufferResult);
	printf("ret at %d is %d\n", __LINE__, bufferResult);

	//RENDERED_VERTEX
	rendered_mem_obj = clCreateBuffer(context, CL_MEM_READ_WRITE, (global_vertex_size * sizeof(Rendered_Vertex)), NULL, &bufferResult);
	printf("ret at %d is %d\n", __LINE__, bufferResult);



	//RENDERED_hits
	buff_counter_mem_obj = clCreateBuffer(context, CL_MEM_READ_WRITE, (global_vertex_size * sizeof(int) * 5), NULL, &bufferResult);
	printf("ret at %d is %d\n", __LINE__, bufferResult);


	//ssssss
	hits_mem_obj = clCreateBuffer(context, CL_MEM_READ_WRITE, (10000000 * sizeof(int) * 2), NULL, &bufferResult);
	printf("ret at %d is %d\n", __LINE__, bufferResult);





	//pIXEL BUFFER
	pixel_mem_obj = clCreateBuffer(context, CL_MEM_READ_WRITE, screen_size_x * screen_size_y * sizeof(Pixel), NULL, &bufferResult);
	printf("ret at %d is %d\n", __LINE__, bufferResult);

}


void gpu_setup_kernel_arguments() {
	cl_int kernelResult;


	// Set the arguments of the kernel
	kernelResult = clSetKernelArg(kernel1, 0, sizeof(cl_mem), &vertex_mem_obj);
	printf("ret at %d is %d\n", __LINE__, kernelResult);
	
	kernelResult = clSetKernelArg(kernel1, 1, sizeof(cl_mem), &player_mem_obj);
	printf("ret at %d is %d\n", __LINE__, kernelResult);

	kernelResult = clSetKernelArg(kernel1, 2, sizeof(cl_mem), &buff_counter_mem_obj);
	printf("ret at %d is %d\n", __LINE__, kernelResult);

	kernelResult = clSetKernelArg(kernel1, 3, sizeof(cl_mem), &rendered_mem_obj);
	printf("ret at %d is %d\n", __LINE__, kernelResult);





	// Set the arguments of the kernel
	kernelResult = clSetKernelArg(kernel2, 0, sizeof(cl_mem), &rendered_mem_obj);
	printf("ret at %d is %d\n", __LINE__, kernelResult);

	kernelResult = clSetKernelArg(kernel2, 1, sizeof(cl_mem), &player_mem_obj);
	printf("ret at %d is %d\n", __LINE__, kernelResult);


	kernelResult = clSetKernelArg(kernel2, 2, sizeof(cl_mem), &hits_mem_obj);
	printf("ret at %d is %d\n", __LINE__, kernelResult);

	kernelResult = clSetKernelArg(kernel2, 3, sizeof(cl_mem), &pixel_mem_obj);
	printf("ret at %d is %d\n", __LINE__, kernelResult);

	//added this to fix garbage output problem
	//ret = clSetKernelArg(kernel, 3, sizeof(int), &LIST_SIZE);


}




void gpu_build_kernel_program(const char* file_name, const char* kernel_name, cl_program* program, cl_kernel* kernel) {



	// Load the kernel source code into the array source_str
	FILE* fp;
	char* source_str;
	size_t source_size;







	fopen_s(&fp, file_name, "r");
	if (!fp) {
		fprintf(stderr, "Failed to load kernel.\n");
		exit(1);
	}
	source_str = (char*)malloc(MAX_SOURCE_SIZE);
	source_size = fread(source_str, 1, MAX_SOURCE_SIZE, fp);
	fclose(fp);
	printf("kernel loading done\n");



	printf("before building\n");
	cl_int programResult;

	// Create a program from the kernel source
	*program = clCreateProgramWithSource(context, 1,
		(const char**)&source_str, (const size_t*)&source_size, &programResult);
	printf("ret at %d is %d\n", __LINE__, programResult);




	// Build the program
	cl_int programBuildResult = clBuildProgram(*program, 1, &device, NULL, NULL, NULL);
	printf("ret at %d is %d\n", __LINE__, programBuildResult);
	if (programBuildResult != CL_SUCCESS) {
		char* log;
		size_t logLength;
		cl_int programBuildInfoResult = clGetProgramBuildInfo(*program, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &logLength);
		log = malloc(logLength + 1);
		programBuildInfoResult = clGetProgramBuildInfo(*program, device, CL_PROGRAM_BUILD_LOG, logLength, log, NULL);

		//assert(programBuildInfoResult == CL_SUCCESS);
		printf("gpu device %s\n", log);
		assert(log);
		free(log);
	}
	printf("Completed building: %s \n", file_name);

	// Create the OpenCL kernel
	cl_int kernelResult;
	*kernel = clCreateKernel(*program, kernel_name, &kernelResult);
	printf("ret at %d is %d\n", __LINE__, kernelResult);

	printf("Created opencl kernel: %s \n", kernel_name);

}




void gpu_init() {



	printf("gpu init start\n");

	// ### Get dgpu device
	cl_platform_id platforms[64];
	unsigned int platformCount;
	cl_int platformResult = clGetPlatformIDs(64, platforms, &platformCount);
	///assert(platformResult == CL_SUCCESS);

	device = NULL;

	for (int i = 0; i < platformCount && device == NULL; ++i) {
		cl_device_id devices[64];
		unsigned int deviceCount;
		cl_int deviceResult = clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_GPU, 64, devices, &deviceCount);


		if (deviceResult == CL_SUCCESS) {
			for (int j = 0; j < deviceCount; ++j) {
				char vendorName[256];
				size_t vendorNameLength;
				cl_int deviceInfoResult = clGetDeviceInfo(devices[j], CL_DEVICE_VENDOR, 256, vendorName, &vendorNameLength);
				if (deviceInfoResult == CL_SUCCESS && !strcmp(vendorName, "NVIDIA Corporation")) {
					device = devices[j];
					printf("gpu device vendor; %s\n", vendorName);
					break;
				}
			}
		}
	}



	cl_uint DeviceInfo[256];
	size_t DeviceInfoLength;

	clGetDeviceInfo(device, CL_DEVICE_NAME, 256, DeviceInfo, &DeviceInfoLength);
	printf("%s     =  0x%d\n", "CL_DEVICE_NAME", *DeviceInfo);

	clGetDeviceInfo(device, CL_DEVICE_MAX_COMPUTE_UNITS, 256, DeviceInfo, &DeviceInfoLength);
	printf("%s     =  0x%d\n", "CL_DEVICE_MAX_COMPUTE_UNITS", *DeviceInfo);

	clGetDeviceInfo(device, CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS, 256, DeviceInfo, &DeviceInfoLength);
	printf("%s     = %d\n", "CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS", *DeviceInfo);


	size_t DeviceInfoSize[256];
	clGetDeviceInfo(device, CL_DEVICE_MAX_WORK_ITEM_SIZES, 256, DeviceInfoSize, &DeviceInfoLength);
	for (int nr = 0; nr < *DeviceInfo; nr++) {
		printf("%s %d    = %d\n", "CL_DEVICE_MAX_WORK_ITEM_SIZES", nr, DeviceInfoSize[nr]);

	}

	clGetDeviceInfo(device, CL_DEVICE_MAX_WORK_GROUP_SIZE, 256, DeviceInfoSize, &DeviceInfoLength);
	printf("%s     = %d\n", "CL_DEVICE_MAX_WORK_GROUP_SIZE", *DeviceInfoSize);



	clGetDeviceInfo(device, CL_DEVICE_MAX_CLOCK_FREQUENCY, 256, &DeviceInfo, &DeviceInfoLength);
	printf("%s     = %d\n", "CL_DEVICE_MAX_CLOCK_FREQUENCY", *DeviceInfo);


	cl_ulong DeviceInfolong;
	clGetDeviceInfo(device, CL_DEVICE_GLOBAL_MEM_SIZE, 256, &DeviceInfolong, &DeviceInfoLength);
	printf("%s     = %llu   ~=  %.1fl GB \n", "CL_DEVICE_GLOBAL_MEM_SIZE", DeviceInfolong, (float)DeviceInfolong / 1000000000);



	clGetDeviceInfo(device, CL_DEVICE_LOCAL_MEM_SIZE, 256, &DeviceInfolong, &DeviceInfoLength);
	printf("%s     = %llu   ~=  %.1fl GB \n", "CL_DEVICE_LOCAL_MEM_SIZE", DeviceInfolong, (float)DeviceInfolong / 1000000000);



	// ### create command queue

	cl_int contextResult;
	context = clCreateContext(NULL, 1, &device, NULL, NULL, &contextResult);
	///assert(contextResult == CL_SUCCESS);



	cl_int commandQueueResult;
	cl_command_queue command_queue = clCreateCommandQueue(context, device, 0, &commandQueueResult);
	printf("ret at %d is %d\n", __LINE__, commandQueueResult);
	assert(commandQueueResult == CL_SUCCESS);


	command_queue_copy = command_queue;



	printf("Finishedeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee\n");
	printf("Finishedeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee\n");
	printf("Finishedeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee\n");
	printf("Finishedeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee\n");
}
