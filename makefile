result: result.csv

result.csv: cuda.o cpu_seq.o openmp.o
	echo "CPU" > result.csv
	./cpu_seq.o >> result.csv
	echo "GPU" >> result.csv
	./cuda.o >> result.csv
	echo "OpenMP" >> result.csv
	./openmp.o >> result.csv

cuda.o: cuda.cu
	nvcc $< -o $@

cpu_seq.o: cpu_seq.cpp
	gcc $< -o $@

openmp.o: openmp.cpp
	gcc $< -o $@ -lomp

clean:
	rm -vf *.o *.out result.csv
