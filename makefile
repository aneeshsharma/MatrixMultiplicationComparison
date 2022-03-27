MAX_SIZE=100000000
MIN_SIZE=1000
BLOCK_SIZE=256

CONSTANT_DEF=-D MAX_SIZE=$(MAX_SIZE) -D MIN_SIZE=$(MIN_SIZE) -D BLOCK_SIZE=$(BLOCK_SIZE)

result: result.csv

result.csv: cuda.o cpu_seq.o openmp.o
	echo "CPU" > result.csv
	./cpu_seq.o >> result.csv
	echo "GPU" >> result.csv
	./cuda.o >> result.csv
	echo "OpenMP" >> result.csv
	./openmp.o >> result.csv

cuda.o: cuda.cu
	nvcc $< -o $@ $(CONSTANT_DEF)
cpu_seq.o: cpu_seq.cpp
	gcc $< -o $@ $(CONSTANT_DEF)

openmp.o: openmp.cpp
	gcc $< -o $@ -lomp $(CONSTANT_DEF)

clean:
	rm -vf *.o *.out result.csv
