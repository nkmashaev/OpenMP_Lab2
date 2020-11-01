#include <cmath>
#include <exception>
#include <stdexcept>
#include "functions.h"

namespace FM
{
	double Function_6::get_value(double x) const
	{
		if (x <= 0.0)
		{
			throw std::runtime_error("Error: Function is underfined");
		}
		
		if (x == 1.0)
		{
			return -1.0;
		}

		double y = std::log(x) / (1 - x);
		return y;
	}
}
