#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

//for random intialize
#include <stdlib.h>
#include <time.h>

//for memset
#include <cstring>

#ifndef MAX_SIZE
    #define MAX_SIZE 100000000
#endif

#ifndef MIN_SIZE
    #define MIN_SIZE 1000
#endif

#ifndef BLOCK_SIZE
    #define BLOCK_SIZE 128
#endif

__global__ void mul_vec_gpu(int * a, int * b, int* c, int size)
{
	int index = blockDim.x * blockIdx.x + threadIdx.x;

	if (index < size)
		c[index] = a[index] * b[index];
}

int main()
{
    printf("Array Size, GPU Kernel Time, Host to Device Time, Device to Host Time, Total GPU Time\n");
    for (int size = MIN_SIZE; size <= MAX_SIZE; size *= 10) {
        int block_size = BLOCK_SIZE;
        cudaError error;

        //number of bytes needed to hold element count
        size_t NO_BYTES = size * sizeof(int);

        // host pointers
        int *h_a, *h_b, *gpu_result;

        //allocate memory for host size pointers
        h_a = (int *)malloc(NO_BYTES);
        h_b = (int *)malloc(NO_BYTES);
        gpu_result = (int *)malloc(NO_BYTES);

        //initialize h_a and h_b vectors randomly
        time_t t;
        srand((unsigned)time(&t));

        for (size_t i = 0; i < size; i++)
        {
            h_a[i] = (int)(rand() & 0xFF);
            
        }

        for (size_t i = 0; i < size; i++)
        {
            h_b[i] = (int)(rand() & 0xFF);
        
        }

        memset(gpu_result, 0, NO_BYTES);

        int *d_a, *d_b, *d_c;
        cudaMalloc((int **)&d_a, NO_BYTES);
        cudaMalloc((int **)&d_b, NO_BYTES);
        cudaMalloc((int **)&d_c, NO_BYTES);

        //kernel launch parameters
        dim3 block(block_size);
        dim3 grid((size / block.x) + 1);

        clock_t mem_htod_start, mem_htod_end;
        mem_htod_start = clock();
        cudaMemcpy(d_a, h_a, NO_BYTES, cudaMemcpyHostToDevice);
        cudaMemcpy(d_b, h_b, NO_BYTES, cudaMemcpyHostToDevice);
        mem_htod_end = clock();

        //execution time measuring in GPU
        clock_t gpu_start, gpu_end;
        gpu_start = clock();

        mul_vec_gpu<<<grid, block>>>(d_a, d_b, d_c, size);
        cudaDeviceSynchronize();
        gpu_end = clock();

        clock_t mem_dtoh_start, mem_dtoh_end;
        mem_dtoh_start = clock();
        cudaMemcpy(gpu_result, d_c, NO_BYTES, cudaMemcpyDeviceToHost);
        mem_dtoh_end = clock();

        printf("%d,", size);

        printf("%4.6f,",
            (double)((double)(gpu_end - gpu_start) / CLOCKS_PER_SEC));

        printf("%4.6f,",
            (double)((double)(mem_htod_end - mem_htod_start) / CLOCKS_PER_SEC));

        printf("%4.6f,",
            (double)((double)(mem_dtoh_end - mem_dtoh_start) / CLOCKS_PER_SEC));

        printf("%4.6f",
            (double)((double)((mem_htod_end - mem_htod_start)
                + (gpu_end - gpu_start)
                + (mem_dtoh_end - mem_dtoh_start)) / CLOCKS_PER_SEC));

        cudaFree(d_c);
        cudaFree(d_b);
        cudaFree(d_a);	
                
        free(gpu_result);
        free(h_a);
        free(h_b);
                
        cudaDeviceReset();
        printf("\n");
    }
	return 0;
}
