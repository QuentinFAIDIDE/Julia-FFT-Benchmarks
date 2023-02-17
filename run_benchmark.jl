using LibSndFile
using FileIO: load, save, loadstreaming, savestreaming
using Plots

# declare list of benchmarks
const benchmark_targets = [
    "fft_naive.R",
    "fft_builtin.R",
    "fft_naive.jl",
    "fft_fftw.jl",
    "fft_naive.py",
    "fft_scipy.py"
]

# parse_benchmark will parse a benchmark file
function parse_benchmark(benchmark_file::String)
    benchmark_content_txt = ""
    try
        # NOTE: we used to run the command ourselves
        # but it proved to buggy (overflowing error code and many more)
        open(string("result_", benchmark_file, ".txt")) do benchmark_file_handler
            benchmark_content_txt = read(benchmark_file_handler, String)
        end
    catch
        println("Fichier de résultat de benchmark manquant, lancez run_all_benchmarks.sh")
        exit(1)
    end
    # parse lines
    lines = split(benchmark_content_txt, "\n") 
    # filter out empty lines
    lines = lines[lines .!= ""] 
    lines = lines[lines .!= "\n"] 
    # check anchor magic string
    if lines[1] != "BENCHMARK RESULT"
        println("Format du fichier de benchmark invalide")
        exit(1)
    end


    # get the time taken and version
    time_taken = parse(Int, lines[2])
    version = lines[3]
    # compute required size of result arrays
    array_size = (length(lines)-3)>>1
    intensities = zeros(array_size)
    frequencies = zeros(array_size)
    # iterate over lines
    for i in 1:(array_size)
        line_no_base = 4 + ((i-1)*2)
        # parse freq
        frequencies[i] = parse(Float64, lines[line_no_base])
        # parse value
        intensities[i] = parse(Float64, lines[line_no_base+1])
    end
    # return benchmark tuple type
    return(
        filename = benchmark_file,
        time_taken = time_taken,
        array_size = array_size,
        version = version,
        intensities = intensities,
        freqs = frequencies
    )
end

function generate_intensity_plot(sample_path::String, image_path::String)
    samp = load(sample_path)
    plot(samp[:,1], fmt = :png)
    savefig(image_path)
end

function generate_freqencies_plot(result)
    plot(result.freqs, result.intensities, line=:stem, fmt = :png)
    savefig(string("figure_",result.filename,".png"))
end

# print the beginning of the document
print(
"""
# Benchmarks de Fast Fourrier Transforms
## Introduction
Ce document va mesurer les performances de différentes
implémentations de l'algorithme de **Fast Fourrier Transform** dans 3 languges:
- Python
- R
- Julia

On utilisera une implémentation maison (dite naive)
et une implémentation d'un package répandu. Le but sera de comparer
les performances des languages entre eux.

## Donnée de test
On utilise un sample de clap pour notre test. La figure
ci-dessous affiche l'intensitée du signal en fonction du temps.

![signal du clapement de mains utilisé comme référence](clap.png)

## Résultats
Les temps de calculs de la transformation de fourier mesurés sont les suivants:
"""
)

# generate intensity plot of reference sample
generate_intensity_plot("data/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav", "clap.png")

# get all results in the same array
results = []
for file in benchmark_targets
    result = parse_benchmark(file)
    push!(results, result)
end

# sort results
results_sorted = sort(results, by=results->results.time_taken)

# affiche les résultats dans l'ordre
for result in results_sorted
    println("\n - `", result.filename, "` a mis **", result.time_taken, "** millisecondes (", result.array_size, " intensités générés)")
end

print(
"""


L'implémentation la plus rapide est celle de R, qui apelle probable
du C++ ou du C avec une librairie spécialisée dans les transformations
de fourrier rapides. Ensuite arrive scipy, puis julia (qui utilise
fftw et a donc un binding avec le C à gérer elle aussi).
Au final, on mesure plutôt l'efficacité du binding C en utilisant
des libraires. Regardons maintenant les résultats des implémentations
dites "naives", c'est à dire implémentation classique de l'algorithme fft
firectement dans le language.
Sans surprise, R est assez lent. Par contre, python est le plus rapide
des 3, ce qui est surprenant au vu de sa réputation.
On notera tout de même que ce benchmark mériterai à être répété avec d'autres version.

Les versions des différents interpréteurs utilisés sont les suivantes:

"""
)

# display versions
for result in results_sorted
    println("\n - `", result.filename, "` est en version **", result.version,"**")
end


print(
"""

## Comparaison visuelle
Nous allons maintenant, pour chaque fichier, produire une figure et comparer
visuellement les fréquences obtenues.


"""
)

# iterate over results and generate/display plot
for result in results_sorted
    generate_freqencies_plot(result)
    print("\n### ", uppercase(result.filename), "\n![image](figure_",result.filename,".png)\n")
end