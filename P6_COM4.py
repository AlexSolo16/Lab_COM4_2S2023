import scipy.io.wavfile as wav 
import matplotlib.pyplot as plt
import wave
import subprocess
import numpy as np

#Carga el archivo de audio WAV 
fs, signal = wav.read('1up.wav')

#Grafica la señal original 
t = [float(i)/fs for i in range(len(signal))]
plt.subplot(2, 1, 1)
plt.plot(t, signal)
plt.title('Señal original')

#Comprime el archivo de audio utilizando el formato MP3
subprocess.call(['ffmpeg', '-i', '1up.wav', '-b:a', '128k', 'archivo_audio_comprimido_1up.mp3'])

#carga el archivo de audio comprimido
wav_file = wave.open('archivo_audio_comprimido_1up.mp3')
signal_comprimido = wav_file.redframes(-1)
signal_comprimido = np.frombuffer(signal_comprimido, 'int16')

#Grafica la señal comprimida
t_comprimido = [float(i)/fs for i in range(len(signal_comprimido))]
plt.subplot(2, 1, 2)
plt.plot(t_comprimido, signal_comprimido)
plt.title('Señal comprimida')

#Ajusta los ejes para ambas graficas 
plt.axis[0, max(t), -32768, 32768]
plt.show()