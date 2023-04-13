clc;
clear;

#Menu para grabar y reproducir una señal de voz
while true
  disp('Seleccionar una opcion: ');
  disp('1. Grabar señal de voz');
  disp('2. Reproducir ultima señal de voz grabada');
  disp('3. Salir');
  opcion = input('Ingrese el numero de la opcion: ');

  switch opcion
    case 1
      disp('Grabando señal de voz... ');
      try
        %Configuracion de la grabacion
        duracion_grabacion = 5; %Duracion de grabacion en segundos
        frecuencia_muestreo = 8000; %Frecuencia de muestreo en Hz
        num_bits = 16; %16 bits por muestra
        num_canales = 1; %Mono

        %Grabacion de la señal de voz
        grabacion = audiorecorder(frecuencia_muestreo, num_bits, num_canales);
        recordblocking(grabacion, duracion_grabacion);
        senal_grabada = getaudiodata(grabacion);
        disp('Señal de voz grabada exitosamente');
      catch
        disp('Error al grabar señal de voz');
      end_try_catch
    case 2
      if exist('senal_grabada', 'var')
        disp('Reproduciendo señal de voz');
        sound(senal_grabada, frecuencia_muestreo);
      else
        disp('No hay señal de voz grabada');
      endif
    case 3
      disp('Saliendo del programa');
      break;
    otherwise
      disp('Opcion invalida');
  endswitch
end
