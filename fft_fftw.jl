using LibSndFile
using FileIO: load, save, loadstreaming, savestreaming
using LinearAlgebra
using FFTW

# load the sample
samp = load("./data/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav")

# convert it to an Array
raw_samples = convert(Array,samp[:,1])

# perform the fft and get time taken
start_time = time()
X = fft(raw_samples[1:2^15])
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