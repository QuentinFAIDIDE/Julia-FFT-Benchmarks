fft_r <- function(x,N) {

    if(N==1){
        return(x)
    }
    x_even <- x[seq(1, N, 2)]
    x_odd <- x[seq(2, N, 2)]

    y0 <- fft_r(x_even,N/2)
    y1 <- fft_r(x_odd,N/2)

    yk <- numeric(N)

    yk[1:(N/2)] <- y0 + y1*exp(-2i*pi*(0:(N/2-1)/N))
    yk[(N/2+1):N] <- y0 - y1*exp(-2i*pi*(0:(N/2-1)/N))

    return(yk)
}

temp <- fft_r(c(1,5,8,9),4)


library(tuneR)

data <- readWave("son/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav")

str(data)

temp <- fft_r(data@left[1:2^15],2^15)

plot(abs(temp),type="h")

temp2 <- fft(data@left[1:2^15])

plot(abs(temp2),type="h")

system.time(fft(data@left[1:2^15]))

