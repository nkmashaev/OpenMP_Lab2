#!/usr/bin/bash

echo "Starting researching script ..."
echo "====================STARTING SCRIPT====================" > lab2_data.txt

lkey="-ftree-parallelize-loops="
for opt_key in -O0 -O1 -O2 -O3; do
	export OMP_NUM_THREADS=1
	export OMP_SCHEDULE="STATIC,1"
	echo "Building executable files with lab2_builder.sh ..."
	./lab2_builder.sh $opt_key
	echo "====================$opt_key optimization====================" >> lab2_data.txt
	echo "Starting consistent tests"
	echo "Calculating consistent_integral..."
	./tester.py ./bin/consistent_integral >> lab2_data.txt
	echo "Calculation vector_sum..."
	./tester.py ./bin/vect_sum >> lab2_data.txt
	echo "Starting parallel tests"
	for var in 1 2 3 4 5 6 7 8; do
		export OMP_NUM_THREADS=$var
		echo "THREAD NUMB = $OMP_NUM_THREADS"
	        echo "===================THREAD NUMB is $OMP_NUM_THREADS=================" >> lab2_data.txt	
		auto_par="${lkey}${var}"
		cd bin
		g++ $auto_par -c ../function_tools/functions.cpp -Wall $opt_key
		g++ $auto_par -c ../ConsistentSolution/consistent_integral.cpp -Wall $opt_key
		g++ $auto_par -c ../ConsistentSolution/vector_sum.cpp -Wall $opt_key
		g++ $auto_par -o vect_sum vector_sum.o functions.o -Wall $opt_key
		g++ $auto_par -o consistent_integral consistent_integral.o functions.o -Wall $opt_key
		rm *.o
		cd ..

		echo "$auto_par"
		echo "Calculating consistent_integral..."
		./tester.py ./bin/consistent_integral >> lab2_data.txt
		echo "Calculating vect_sum..."
		./tester.py ./bin/vect_sum >> lab2_data.txt
		echo "OMP Parallel"
		echo "Calculating SMPD..."
		./tester.py ./bin/SMPD >> lab2_data.txt
		echo "Calculating for_tid..."
		./tester.py ./bin/for_tid >> lab2_data.txt
		echo "Calculating for_critical..."
		./tester.py ./bin/for_critical >> lab2_data.txt
		echo "Calculating for_atomic..."
		./tester.py ./bin/for_atomic >> lab2_data.txt
		echo "Calculating for_lock..."
		./tester.py ./bin/for_lock >> lab2_data.txt
		echo "Calculating for_reduction..."
		./tester.py ./bin/for_reduction >> lab2_data.txt
	done

	echo ""
	export OMP_NUM_THREADS=4
	echo "THREAD_NUMB = $OMP_NUM_THREADS"
	echo "===================THREAD NUMB is $OMP_NUM_THREADS=================" >> lab2_data.txt
	
	for method in STATIC DYNAMIC GUIDED; do
		echo "===================METHOD is $method===================" >> lab2_data.txt
		for chunk in 1 10 50 100 1000 100000 500000; do
			echo "====================CHUNK SIZE is $chunk====================" >> lab2_data.txt
			export OMP_SCHEDULE="$method,$chunk"
			echo "METHOD is $OMP_SCHEDULE"
        	        echo "Calculating for_tid..."
                	./tester.py ./bin/for_tid >> lab2_data.txt
              		echo "Calculating for_critical..."
              		./tester.py ./bin/for_critical >> lab2_data.txt
               		echo "Calculating for_atomic..."
                	./tester.py ./bin/for_atomic >> lab2_data.txt
                	echo "Calculating for_lock..."
                	./tester.py ./bin/for_lock >> lab2_data.txt
                	echo "Calculating for_reduction..."
                	./tester.py ./bin/for_reduction >> lab2_data.txt
		done
	done

done
