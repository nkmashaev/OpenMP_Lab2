#!/usr/bin/python3

import os
import subprocess
import sys


def one_iter_time(file_name):
    process = subprocess.Popen(file_name, stdout=subprocess.PIPE)
    stdout, stderr = process.communicate()
    rec_data_list = stdout.decode().split("\n")
    exec_time = float(rec_data_list[0].split()[2])
    return exec_time


if __name__ == "__main__":
    iter_numb = 10
    assert 2 == len(sys.argv)
    file_name = sys.argv[1]

    total_time = one_iter_time(file_name)
    min_time = total_time
    max_time = total_time
    for i in range(1, iter_numb, 1):
        exec_time = one_iter_time(file_name)
        total_time += exec_time
        if min_time > exec_time:
            min_time = exec_time
        if max_time < exec_time:
            max_time = exec_time
    average = total_time / iter_numb

    name = file_name.split("/")[-1]
    print(
        name.ljust(20, " "),
        "{:.11E}".format(min_time).center(20, " "),
        "{:.11E}".format(max_time).center(20, " "),
        "{:.11E}".format(average).center(20, " "),
        sep="|",
    )
