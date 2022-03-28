#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cstring>
#include <pthread.h>

#ifndef MAX_SIZE
    #define MAX_SIZE 10000000
#endif

#ifndef MIN_SIZE
    #define MIN_SIZE 1000
#endif

#ifndef THREAD_COUNT
    #define THREAD_COUNT 8
#endif

struct ThreadParam {
    int* a;
    int* b;
    int* c;
    int size;
    int ti;
    int step;
};

void* worker(void* ptr) {
    struct ThreadParam* param = (struct ThreadParam*) ptr;

    int size = param->size;
    int step = param->step;
    for (int i = param->ti; i < size; i += step) {
        param->c[i] = param->a[i] * param->b[i];
    }

    return 0;
}

void mul_vec_pthread(int* a, int* b, int* c, int size) {
    pthread_t threads[THREAD_COUNT];
    struct ThreadParam param[THREAD_COUNT];
    for (int i = 0; i < THREAD_COUNT; i++) {
        param[i] = { a, b, c, size, i, THREAD_COUNT};
        pthread_create(&threads[i], NULL, worker, (void*) &param[i]);
    }

    for (int i = 0; i < THREAD_COUNT; i++) {
        pthread_join(threads[i], NULL);
    }
}

int main()
{
    printf("Array Size, CPU Time\n");
	for (int size = MIN_SIZE; size <= MAX_SIZE; size *= 2) {
        int block_size = 128;

        //number of bytes needed to hold element count
        size_t NO_BYTES = size * sizeof(int);

        // host pointers
        int *h_a, *h_b, *cpu_result;

        //allocate memory for host size pointers
        h_a = (int *)malloc(NO_BYTES);
        h_b = (int *)malloc(NO_BYTES);
        cpu_result = (int *)malloc(NO_BYTES);

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

        memset(cpu_result, 0, NO_BYTES);

        //multiplication in CPU
        clock_t cpu_start, cpu_end;
        cpu_start = clock();
        mul_vec_pthread(h_a, h_b, cpu_result, size);
        cpu_end = clock();


        printf("%d, %4.6f\n", size,
            (double)((double)(cpu_end - cpu_start) / CLOCKS_PER_SEC));
                
        free(h_a);
        free(h_b);		
    }
    return 0;
}
