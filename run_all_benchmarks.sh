#!/bin/bash
for bench in fft_*
do
    echo "Running $bench..."

    # pick binary
    IFS='.'
    read -a strarr <<< "$bench"

    binary=""
    if [ "${strarr[1]}" == "py" ]
    then
        binary="python"
    fi
    if [ "${strarr[1]}" == "jl" ]
    then
        binary="julia"
    fi
    if [ "${strarr[1]}" == "R" ]
    then
        binary="Rscript"
    fi

    # abort if extension is invalid
    if [ "$binary" == "" ]
    then
        echo "This file has wrong extension: $bench"
        exit 1
    fi

    # R sucks, so it has its own containement branch
    if [ "$binary" == "Rscript" ]
    then
        echo "Running: $binary $bench &> result_$bench.txt"
        bash -c "${binary} ${bench} &> result_${bench}.txt"
    else
        echo "Running: $binary $bench 1> result_$bench.txt"
        bash -c "${binary} ${bench} 1> result_${bench}.txt"
    fi
done