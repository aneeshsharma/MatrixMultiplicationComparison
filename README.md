# Matrix Multiplication Performance Comparison

This project intends to compare performance of vector multiplication on various
parallel computing platforms - OpenMP, CUDA and pthread.

## Prerequisites

Following prerequisites are required in order to compile and run this project.
- CUDA - [The CUDA Development tools](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html#installing-cuda-development-tools)
- OpenMP - If you are using GCC, OpenMP is already provided
- `gcc` - The GCC compiler (should be installed by default on most major linux distributions)
- `make` - [The GNU Make utility](https://www.gnu.org/software/make/)

> The project is tested on linux.

## Usage

Clone this repository using
```
git clone https://github.com/aneeshsharma/MatrixMultiplicationComparison
```

You can use `make` to compile and run all the tests.

```bash
cd MatrixMultiplicationComparison
make result
```

This should output a `result.csv` file containing all the results for each implementation.

You can use `make clean` to clean the result and object files output by the compiler

`make clean result` to clean the results and rerun the tests from scratch.

