#ifndef _FUNCTIONS_H_
#define _FUNCTIONS_H_
#include <cmath>

namespace FM
{
	const double pi = std::atan(1.0) * 4.0;

	class IFunction
	{
	public:
		virtual double get_value(double x) const =0;
		virtual ~IFunction() {};
	};

	class Function_6 : public IFunction
	{
	public:
		virtual double get_value(double x) const;
		virtual ~Function_6() {};
	};
}

#endif
