function fft_julia(x,N::Int64)
    # x vecteur de données, N la taille
    if(N<=1)
        return x
    end
    x_even = x[1:2:N]
    x_odd = x[2:2:N]
    y0 = fft_julia(x_even,convert(Int64,N/2))
    y1 = fft_julia(x_odd,convert(Int64,N/2))
    
    print(y0)

    yk = zeros(Complex,N)

    for k::Int64 in 1:N/2
        omega = exp.(-2*pi*(k-1)*im/N)

        yk[k] = y0[k] + omega.*y1[k]
        yk[convert(Int64,k+N/2)] = y0[k] - omega.*y1[k]
    end
    return yk
end

temp = fft_julia([1,5,8,9],4)
temp






using FFTW

FFTW.fft([1,5,8,9])
temp


using Pkg

Pkg.add("FileIO")
using LibSndFile
using FileIO: load, save, loadstreaming, savestreaming
using Plots
using LinearAlgebra

# load audio file
samp = load("son/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav")

# draw signal
plot(samp)
# draw dft
snare_dft = fft_julia(samp[1:2^15, 1],length(samp[1:2^15, 1])) # [:,1] pour accéder aux samples
plot(abs.(snare_dft))
