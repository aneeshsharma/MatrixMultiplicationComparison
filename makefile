result: result.csv

result.csv: cuda.o cpu_seq.o
	echo "CPU" > result.csv
	./cpu_seq.o >> result.csv
	echo "GPU" >> result.csv
	./cuda.o >> result.csv

cuda.o: cuda.cu
	nvcc $< -o $@

cpu_seq.o: cpu_seq.cpp
	gcc $< -o $@

clean:
	rm *.o *.out result.csv
