library(tuneR)

fft_naive <- function(x,N) {

    if(N==1){
        return(x)
    }
    x_even <- x[seq(1, N, 2)]
    x_odd <- x[seq(2, N, 2)]

    y0 <- fft_naive(x_even,N/2)
    y1 <- fft_naive(x_odd,N/2)

    yk <- numeric(N)

    yk[1:(N/2)] <- y0 + y1*exp(-2i*pi*(0:(N/2-1)/N))
    yk[(N/2+1):N] <- y0 - y1*exp(-2i*pi*(0:(N/2-1)/N))

    return(yk)
}

raw_samples <- readWave("data/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav")

start_time <- floor(as.numeric(Sys.time())*1000)
freqs_intensities <- fft_naive(raw_samples@left[1:2^15],2^15)
time_taken <- floor(as.numeric(Sys.time())*1000)-start_time

sr <- 44100
xdft <- freqs_intensities[1:(length(freqs_intensities)/2+1)]
DF <- sr/length(freqs_intensities)
freq <- seq(from=0, to=sr/2, by=DF)

message("BENCHMARK RESULT")
message(time_taken)
message(strsplit(version[['version.string']], ' ')[[1]][3])

for(i in seq_along(freq)) {
    message(freq[i])
    message(Re(xdft[i]))
}
