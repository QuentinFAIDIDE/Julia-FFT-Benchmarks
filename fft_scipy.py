import numpy as np
import random
from scipy.io import wavfile
from scipy import fft
import time
import math
import sys

# load file    
samplerate, data = wavfile.read('data/Ultrasonic_-_Slap_House_Essentials_-_Clap_04.wav')

# compute fft
start_time = time.time()
freq_domain_intensities = fft.fft(data[:,0])
computing_time_ms = int(math.floor(1000*(time.time()-start_time)))

# drop computing time
print("BENCHMARK RESULT")
print(computing_time_ms)
print(sys.version)

# compute frequencies of beginning of bins for each array value
freq = np.arange(0,samplerate/2,samplerate/len(freq_domain_intensities))
# ignore complex intensities and pick the real part
real_freq_intensities = freq_domain_intensities[0:int(len(freq_domain_intensities)/2+1)]

# print each frequency bin and its intensity
for i in range(len(freq)):
    print(freq[i])
    print(real_freq_intensities[i].real)