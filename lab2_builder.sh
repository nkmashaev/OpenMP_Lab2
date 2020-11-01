#!/usr/bin/bash

# Creating bin directory if not exist
# Change current directory to bin one
create_bin_dir ()
{
	if [[ ! -e bin ]]; then
		echo "Creating bin directory"
		mkdir bin
 	fi		
	cd bin
}

# Delete *.o files
delete_temp_o ()
{
	rm *.o
}

#Determine optimization key
echo "========================================"
echo "Starting lab2_builder.sh"
opt_key=-O0
if [ $# -gt 1 ]; then
	echo "Error: Too many arguments!"
	echo "Expected optimization key"
elif [ $# == 1 ]; then
	opt_key=$1
fi
echo "========================================"
echo "Optimization key: $opt_key"

create_bin_dir
# Create temporary *.o files
g++ -c ../function_tools/functions.cpp -Wall $opt_key
g++ -c ../ConsistentSolution/consistent_integral.cpp -Wall $opt_key
g++ -c ../ConsistentSolution/vector_sum.cpp -Wall $opt_key
g++ -fopenmp -c ../ParallelSolution/SMPD.cpp -Wall $opt_key
g++ -fopenmp -c ../ParallelSolution/for_tid.cpp -Wall $opt_key
g++ -fopenmp -c ../ParallelSolution/for_critical.cpp -Wall $opt_key
g++ -fopenmp -c ../ParallelSolution/for_atomic.cpp -Wall $opt_key
g++ -fopenmp -c ../ParallelSolution/for_lock.cpp -Wall $opt_key
g++ -fopenmp -c ../ParallelSolution/for_reduction.cpp -Wall $opt_key

# Create bin files
echo "========================================"
echo "Creating binary files..."
echo "========================================"

ft="functions.o"

echo "Creating consistent_integral binary"
g++ -o consistent_integral consistent_integral.o $ft -Wall $opt_key
echo "Creating vect_sum binary"
g++ -o vect_sum vector_sum.o $ft -Wall $opt_key
echo "Creating SMPD binary"
g++ -fopenmp -o SMPD SMPD.o $ft -Wall $opt_key
echo "Creation for_tid binary"
g++ -fopenmp -o for_tid for_tid.o $ft -Wall $opt_key
echo "Creation for_critical binary"
g++ -fopenmp -o for_critical for_critical.o $ft -Wall $opt_key
echo "Creation for_atomic binary"
g++ -fopenmp -o for_atomic for_atomic.o $ft -Wall $opt_key
echo "Creation for_lock binary"
g++ -fopenmp -o for_lock for_lock.o $ft -Wall $opt_key
echo "Creation for_reduction binary"
g++ -fopenmp -o for_reduction for_reduction.o $ft -Wall $opt_key

echo "========================================"

# Delete temporary *.o files
delete_temp_o
cd ..

echo "Building process completed!"
echo "========================================"
