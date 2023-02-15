using OutputCollectors

# declare list of benchmarks
const benchmark_targets = [
    "fft_naive.R",
    "fft_builtin.R",
    "fft_naive.jl",
    "fft_fftw.jl",
    "fft_naive.py",
    "fft_scipy.py"
]


# run_command_and_get_stdout runs commands and return code and stdout
function run_command_and_get_stdout(command::Cmd)
    oc = OutputCollector(command)
    return (
      output = collect_stdout(oc), 
      errors = collect_stderr(oc),  
      response_code = oc.P.exitcode
    )
  end

# run_benchmark will execute a benchmark file using the command binary (eg: python / Rscript / julia)
function run_benchmark(benchmark_file::String, command::String)
    # run the command and get stdout
    results = run_command_and_get_stdout(`$command $benchmark_file`)
    # abort on process error code
# BUG: response code is: -9223372036854775808
# let's not keep that test then
#    if results.response_code != 0
#        print("response code is: ", results.response_code)
#        exit(1)
#    end
    # split lines
    lines = split(results.output, "\n")
    print(lines)
    print(results.output)
    # get the timestamp
    # compute required size of result arrays
    # iterate over lines
        # parse freq
        # parse value
    # return benchmark Union type
end

# print the beginning of the document
print(
"""
# Benchmarks de Fast Fourrier Transforms
Ce document va mesurer les performances de différentes
implémentations de l'algorithme de **Fast Fourrier Transform** dans 3 languges:
- Python
- R
- Julia

On utilisera une implémentation maison (dite naive)
et une implémentation d'un package répandu. Le but sera de comparer
les performances des languages entre eux.
"""
)

run_benchmark("fft_naive.py", "python")
