#include <iostream>
#include <chrono>
#include <iomanip>

int main(int argc, char*argv[])
{
	unsigned int vect_size = 100000000;
	double *vect1 = new double[vect_size];
	double *vect2 = new double[vect_size];
	double *vects = new double[vect_size];
	
	auto start_clock = std::chrono::system_clock::now();
	for (unsigned int i = 0; i < vect_size; ++i)
	{
		if (i % 2 == 0)
		{
			vect1[i] = 0.0;
			vect2[i] = 1.0;
		}
		else
		{
			vect1[i] = 1.0;
			vect2[i] = 0.0;
		}

		vects[i] = vect1[i] + vect2[i];
	}
	auto end_clock = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed = end_clock - start_clock;

	std::cout << std::scientific << std::setprecision(11);
	std::cout << "Computational time: " << elapsed.count() << " s\n";

	delete []vects;
	delete []vect2;
	delete []vect1;

	return 0;
}
