import numpy as np
import random
from scipy.io import wavfile
import time
import math
import sys

def fft_naive(x):
    N = len(x)
    if N % 2 > 0:
        raise ValueError("length must be a power of 2")
    elif N <= 2:
        n = np.arange(N)
        k = n.reshape((N, 1))
        M = np.exp(-2j * np.pi * k * n / N)
        return np.dot(M, x)
    else:
        X_even = fft_naive(x[::2])
        X_odd = fft_naive(x[1::2])
        terms = np.exp(-2j * np.pi * np.arange(N) / N)
        return np.concatenate([X_even + terms[:int(N/2)] * X_odd,
                               X_even + terms[int(N/2):] * X_odd])

# load file    
samplerate, data = wavfile.read('data/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav')

# compute fft
start_time = time.time()
freq_domain_intensities = fft_naive(data[:2**15,0])
computing_time_ms = int(math.floor(1000*(time.time()-start_time)))

# drop computing time
print("BENCHMARK RESULT")
print(computing_time_ms)
print(sys.version)

# compute frequencies of beginning of bins for each array value
freq = np.arange(0,samplerate/2+1,samplerate/len(freq_domain_intensities))
# ignore complex intensities and pick the real part
real_freq_intensities = freq_domain_intensities[0:int(len(freq_domain_intensities)/2+1)]

# print each frequency bin and its intensity
for i in range(len(freq)):
    print(freq[i])
    print(real_freq_intensities[i].real)