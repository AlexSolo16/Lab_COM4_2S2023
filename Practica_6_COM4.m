clc;
clear;

%Comprueba si estamos ejecutando en MATLAB u OCTAVE
if(exist('OCTAVE_VERSION', 'builtin')~=0)
  %Estamos en Octave
  pkg load signal;
end

%Menu principal
opcion = 0;
while opcion ~= 9
  %Menu de opciones
  disp('Seleccione una opcion: ')
  disp('1. Grabar')
  disp('2. Reproducir')
  disp('3. Graficar')
  disp('4. Graficar densidad')
  disp('5. Graficar y aplicar filtros RFI y RII')
  disp('6. Aplicar y grafica transformada Z')
  disp('7. Conmprimir señal utilizando DCT y graficar')
  disp('8. Reproducir todos los audios')
  disp('9. Salir')
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
      try
        %Cargar el archivo de audio
        [input_signal, fs] = audioread('audio.wav');
        %Diseñar el filtro RFI
        fc = 1000;
        bw = 500;
        %Calcule la frecuencia normalizada
        Wn = [fc-bw/2, fc+bw/2]/(fs/2);
        %Diseñar el filtro Butterworth de segundo orden
        [b, a] = butter(2, Wn);
        %Diseñar el filtro Notch de segundo orden para eliminar interferencias
        fn = 1200;
        Wn_notch = fn/(fs/2);
        [b_notch, a_notch] = pei_tseng_notch(Wn_notch, 0.1);
        %Combinar los dos filtros en serie
        b_total = conv(b, b_notch);
        a_total = conv(a, a_notch);
        %Aplicar el filtro RFI a la señal de audio
        filtered_signal_RFI = filter(b_total, a_total, input_signal);
        %Guardar audio filtrado con RFI
        audiowrite('audio_con_RFI.wav', filtered_signal_RFI, fs);
        %Diseñar el filtro RII
        fc = 1000;
        gain = 20;
        %Calcule la frecuencia normalizada
        Wn = fc/(fs/2);
        %Diseñar el filtro Chebyshev de tercer orden con un polo real y dos polos complejos conjugados
        [b, a] = cheby1(3, gain, Wn, 'high');
        %Aplicar el filtro RII a la señal de audio
        filtered_signal_RII = filter(b, a, filtered_signal_RFI);
        %Guardar audio filtrado con RII
        audiowrite('audio_con_RII.wav', filtered_signal_RII, fs);
        %Graficar la señal de audio original
        t = 0:1/fs:(length(input_signal)-1)/fs;
        figure();
        plot(t, input_signal);
        xlabel('Tiempo (s)');
        ylabel('Amplitud')
        title('Señal original');
        %Graficar la señal de audio filtrada con el filtro RFI
        t = 0:1/fs:(length(filtered_signal_RFI)-1)/fs;
        figure();
        plot(t, filtered_signal_RFI);
        xlabel('Tiempo (s)');
        ylabel('Amplitud');
        title('Señal filtrada con filtro RFI');
        %Graficar la señal de audio filtrada con el filtro RII
        t = 0:1/fs:(length(filtered_signal_RII)-1)/fs;
        figure();
        plot(t, filtered_signal_RII);
        xlabel('Tiempo (s)');
        ylabel('Amplitud');
        title('Señal filtrada con filtro RII');
      catch
        disp('Error al graficar el audio... ');
      end_try_catch
    case 6
      try
        [x, fs] = audioread('audio.wav');
        %Convertir a señal monoaural
        x = mean(x, 2);
        %Calcular transformada Z
        z = tf(x, 1);
        %Obtener coeficientes de la Transformada Z
        [b, a] = tfdata(z, 'v');
        %Aplicar Transformada Z al archivo de audio
        y = filter(b, a, x);
        %Graficar señal original y señal con Transformada Z aplicada
        t = 0:1/fs:(length(x)-1)/fs;
        subplot(2, 1, 1);
        plot(t, x);
        xlabel('Tiempo (s)');
        ylabel('Amplitud');
        title('Señal original');

        subplot(2, 1, 2);
        plot(t, y);
        xlabel('Tiempo (s)');
        ylabel('Amplitud');
        title('Señal con Transformada Z aplicada');
        %Escribir archivo de audio WAV con transformada Z aplicada
        audiowrite('archivo_audio_con_Z.wav', y, fs);
      catch
        disp('Error al graficar el audio... ');
      end_try_catch
    case 7
      try
        #Leer el archivo de audio
        [y, fs] = audioread('audio.wav');

        #Realizar DCT
        dct_y = dct(y);

        #Establecer el umbral para la compresion
        umbral = 0.1;

        #Comprimir DCT
        dct_y_comprimido = dct_y .* (abs(dct_y) > umbral);

        #Realizar la inversa de la DCT para obtener el archivo de audio comprimido
        y_comprimido = idct(dct_y_comprimido);

        #Graficar el archivo inicial y final
        t = (0:length(y)-1)/fs;
        t_comp = (0:length(y_comprimido)-1)/fs;

        subplot(2, 1, 1);
        plot(t, y);
        title('Archivo de audio inicial')
        xlabel('Tiempo (s)');
        ylabel('Amplitud')

        subplot(2, 1, 2);
        plot(t_comp, y_comprimido);
        title('Archivo de audio comprimido')
        xlabel('Tiempo (s)');
        ylabel('Amplitud')

        #Escribir archivo de audio en WAV
        audiowrite('archivo_comprimido.wav', y_comprimido, fs);
      catch
        disp('Error al graficar el audio... ');
      end_try_catch
    case 8
      try
        %Audio original
        disp('Audio original: ');
        [data, fs] = audioread('audio.wav');
        sound(data, fs);
        %Audio Filtro RFI
        disp('Audio filtro RFI: ');
        [data, fs] = audioread('audio_con_RFI.wav');
        sound(data, fs);
        %Audio Filtro RII
        disp('Audio filtro RII: ');
        [data, fs] = audioread('audio_con_RII.wav');
        sound(data, fs);
        %Audio filtrado Transformada Z
        disp('Audio filtrado con la transformada Z: ');
        [data, fs] = audioread('archivo_audio_con_Z.wav');
        sound(data, fs);
        %Audio comprimido a formato Ogg
        disp('Audio comprimido DCT: ');
        [data, fs] = audioread('archivo_comprimido.wav');
        sound(data, fs);
      catch
        disp('Error al reproducir el audio... ');
      end_try_catch
    case 9
      %Salir
      disp('Saliendo del programa... ');
    otherwise
      disp('Opcion no valida');
  endswitch

endwhile


