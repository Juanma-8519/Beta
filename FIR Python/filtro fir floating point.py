import numpy as np
import matplotlib.pyplot as plt

#Taken by fiiir.com
#Band pass filter (windowed-sinc)
#Sampling Rate 2000Hz
#fL = 200Hz
#bL = 160Hz
#fH = 400Hz
#bH = 160Hz
#Rectangular window type

coeffs = np.array ([
    0.001393308741230785,
    0.000000000000000004,
    -0.004179926223692371,
    -0.006231066118073347,
    -0.001044981555923163,
    0.009346599177109963,
    0.063546273476889611,
    -0.000000000000000025,
    -0.110994133554180363,
    -0.148311121291790693,
    -0.043024273765539467,
    0.130934780703932885,
    0.217129080820075593,
    0.130934780703931580,
    -0.043024273765539120,
    -0.148311121291790804,
    -0.110994133554180474,
    -0.000000000000000054,
    0.063546273476889764,
    0.009346599177110055,
    -0.001044981555923101,
    -0.006231066118073373,
    -0.004179926223692395,
    -0.000000000000000025,
    0.001393308741230773,
])


t = np.linspace(0,1.0,2001)

sin_50Hz = np.sin(2*np.pi*50*t)
sin_300Hz = np.sin(2*np.pi*300*t)
sin_600Hz = np.sin(2*np.pi*600*t)

original_signal = sin_50Hz+sin_300Hz+sin_600Hz
#Reescale Amplitude to 0-1
original_signal = original_signal /3

plt.plot(t[:500],sin_50Hz[:500],label='sin_50Hz')
plt.plot(t[:500],sin_300Hz[:500],label='sin_300Hz')
plt.plot(t[:500],sin_600Hz[:500],label='sin_600Hz')
plt.plot(t[:500],original_signal[:500],label='addition')
plt.legend()
plt.show()

filtered_signal = np.convolve(original_signal,coeffs)
plt.plot(t[:500],original_signal[:500],label='input')
plt.plot(t[:500],filtered_signal[:500],label='output')
plt.show()