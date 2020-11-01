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
	double sum = 0.0;
	#pragma omp parallel shared(x_start, x_step, \
				    sum,             \
				    chunk_numb)      \
			     private(curr_x, func)   
	{
		double thread_sum = 0.0;
		
		#pragma omp for schedule(runtime)
		for (unsigned int i = 0; i < chunk_numb; ++i)
		{
			curr_x = x_start + (i + 0.5) * x_step;
			thread_sum += func.get_value(curr_x);
		}

		#pragma omp atomic
		sum += thread_sum;
	}	

	double integration_result = sum * x_step;
	double precise_integ_res = -FM::pi * FM::pi / 6.0;
	double calc_error = std::abs(integration_result - precise_integ_res);
	auto end_clock = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed = end_clock - start_clock;
	
	std::cout << std::scientific << std::setprecision(11);
	std::cout << "Computational time: " << elapsed.count() << " s\n";
	std::cout << "Integration result: " << integration_result << "\n";
	std::cout << "Precise value: " << precise_integ_res << "\n";
	std::cout << "Calculation error: " << calc_error << std::endl;

	return 0;
}
