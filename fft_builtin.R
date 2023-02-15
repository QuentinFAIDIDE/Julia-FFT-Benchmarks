library(tuneR)

raw_samples <- readWave("data/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav")

start_time <- floor(as.numeric(Sys.time())*1000)
freqs_intensities <- fft(raw_samples@left[1:2^15],2^15)
time_taken <- floor(as.numeric(Sys.time())*1000)-start_time

sr <- 44100
xdft <- freqs_intensities[1:(length(freqs_intensities)/2+1)]
DF <- sr/length(freqs_intensities)
freq <- seq(from=0, to=sr/2, by=DF)

message("BENCHMARK RESULT")
message(time_taken)

for(i in seq_along(freq)) {
    message(freq[i])
    message(Re(xdft[i]))
}
