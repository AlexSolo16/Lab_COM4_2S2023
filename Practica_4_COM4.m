clc;
clear;

%Comprueba si estamos ejecutando en MATLAB u OCTAVE
if(exist('OCTAVE_VERSION', 'builtin')~=0)
  %Estamos en Octave
  pkg load signal;
end

%Menu principal
opcion = 0;
while opcion ~= 5
  %opcion = input('Seleccione una opcion: \n 1. Grabar audio\n 2. Reproducir audio \n 3. Graficar audio\n 4. Salir\n');
  %Menu de opciones
  disp('Seleccione una opcion: ')
  disp('1. Grabar')
  disp('2. Reproducir')
  disp('3. Graficar')
  disp('4. Graficar densidad')
  disp('5. Salir')
  opcion = input('Ingrese su eleccion: ');

  switch opcion
    case 1
      %Grabacion de audio
      try
        duracion = input('Ingrese la duracion de la grabacion en segundos: ');
        disp('Comenzando la grabacion... ')
        recObj = audiorecorder;
        recordblocking(recObj, duracion);
        disp('Grabacion finalizada');
        data = getaudiodata(recObj);
        audiowrite('audio.wav', data, recObj.SampleRate);
        disp('Archivo de audio grabado exitosamente');
      catch
        disp('Error al grabar el audio');
      end_try_catch
    case 2
      %Reproduccion de audio
      try
        [data, fs] = audioread('audio.wav');
        sound(data, fs);
      catch
        disp('Error al reproducir el audio.');
      end_try_catch
    case 3
      %Grafico de audio
      try
        [data, fs] = audioread('audio.wav');
        tiempo = linspace(0, length(data)/fs, length(data));
        plot(tiempo, data);
        xlabel('Tiempo (s)');
        ylabel('Amplitud');
        title('Audio')
      catch
        disp('Error al graficar el audio.');
      end_try_catch
    case 4
      %Graficando espectro de frecuencia
      try
        disp('Graficando espectro de frecuencia');
        [audio, Fs] = audioread('audio.wav');
        N = length(audio);
        f = linspace(0, Fs/2, N/2+1);
        ventana = hann(N);
        Sxx = pwelch(audio, ventana, 0, N, Fs);
        plot(f, 10*log10(Sxx(1:N/2+1)));
        xlabel('Frecuencia (Hz)');
        ylabel('Densidad espectral de potencia (dB/Hz)');
        title('Espectro de frecuencia de la señal grabada');
      catch
        disp('Error al graficar el audio');
      end_try_catch
    case 5
      %Salir
      disp('Saliendo del programa... ');
    otherwise
      disp('Opcion no valida');
  endswitch

endwhile


