using LibSndFile
using FileIO: load, save, loadstreaming, savestreaming
using LinearAlgebra

fft_naive = function (x)
    N = length(x)
    if N % 2 > 0
        error("length must be a power of 2")
        exit(1)
    elseif N <= 2
        n = 0:(N-1)
        M = exp.(-2im * pi * (n * transpose(n))/N)
        return M * x
    else 
        X_odd = fft_naive(x[1:2:length(x)])
        X_even = fft_naive(x[2:2:length(x)])  
        terms = exp.(-2im * pi * (0:(N-1)) / N)
        return vcat(X_odd + (*).(terms[1:convert(Int,(N/2))],X_even) , X_even + (*).(terms[convert(Int,(N/2))+1:length(x)],X_odd))
    end
end

# load the sample
samp = load("./data/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav")

# convert it to an Array
raw_samples = convert(Array,samp[:,1])

# perform the fft and get time taken
start_time = time()
X = fft_naive(raw_samples[1:2^15])
time_taken_ms = trunc(Int, (time()-start_time)*1000)

# print time taken to stdout
print("BENCHMARK RESULT\n")
print(time_taken_ms,"\n")

# convert data to something properly formatted
sr = 44100
xdft = X[1:convert(Int,length(X)/2+1)]
DF = sr/length(X)
freq = 0:DF:sr/2

# print data stdout
for i in eachindex(xdft)
    print(freq[i], "\n")
    print(real(xdft[i]), "\n")
end