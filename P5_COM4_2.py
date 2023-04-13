#Practica 5 Python
import numpy as np 
import scipy.signal as signal 
import scipy.io.wavfile as wav 
import matplotlib.pyplot as plt

#Leer archivo de audio WAV 
fs, x = wav.read('1up.wav')
#convertir a señal monoaural
x = np.mean(x, axis=1)
#Calcular transformada Z 
z = signal.TransferFunction([1.0], [1.0, 0.0], dt=1/fs)
#Obtener coeficientes de la transformada Z
b, a = z.num, z.den
#Aplicar transformada Z al archivo de audio 
y = signal.lfilter(b, a, x)
#Graficar señal original y señal con transformada Z aplicada 
t = np.arange(len(x))/float(fs)
plt.subplot(2, 1, 1)
plt.plot(t, x)
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.title('Señal original')

plt.subplot(2, 1, 2)
plt.plot(t, y)
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.title('Señal con transformada Z aplicada')

plt.show()

#Escribir archivo de audio WAV con transformada Z aplicada 
wav.write('archivo_audio_con_Z_py.wav', fs, y.astype(np.int16))