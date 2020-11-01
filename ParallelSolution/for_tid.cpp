#include "../function_tools/functions.h"
#include <iostream>
#include <iomanip>
#include <chrono>
#include <omp.h>

int main(int argc, char*argv[])
{
	unsigned int chunk_numb = 100000000;
	double x_start = 0.0;
	double x_end = 1.0;
	double x_step = (x_end - x_start) / chunk_numb;
	FM::Function_6 func;
	
	auto start_clock = std::chrono::system_clock::now();
	double curr_x = 0.0;
	double *thread_sum;
	unsigned int nthreads = 0;

	#pragma omp parallel shared(x_start, x_step, \
				    nthreads,        \
				    chunk_numb,      \
			            thread_sum)      \
			     private(curr_x, func)   
	{
		#pragma omp master
		{
			nthreads = omp_get_num_threads();
			thread_sum = new double[nthreads];
			for (unsigned int i = 0; i < nthreads; ++i)
			{
				thread_sum[i] = 0.0;
			}
		}
		
		#pragma omp barrier

		unsigned int curr_tid = omp_get_thread_num();
		#pragma omp for schedule(runtime)
		for (unsigned int i = 0; i < chunk_numb; ++i)
		{
			curr_x = x_start + (i + 0.5) * x_step;
			thread_sum[curr_tid] += func.get_value(curr_x);
		}
	}	

	double integration_result = 0.0;
	for (unsigned int i = 0; i < nthreads; ++i)
	{
		integration_result += thread_sum[i];
	}
	integration_result *= x_step;
	double precise_integ_res = -FM::pi * FM::pi / 6.0;
	double calc_error = std::abs(integration_result - precise_integ_res);
	auto end_clock = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed = end_clock - start_clock;
	
	std::cout << std::scientific << std::setprecision(11);
	std::cout << "Computational time: " << elapsed.count() << " s\n";
	std::cout << "Integration result: " << integration_result << "\n";
	std::cout << "Precise value: " << precise_integ_res << "\n";
	std::cout << "Calculation error: " << calc_error << std::endl;

	delete []thread_sum;
	return 0;
}
