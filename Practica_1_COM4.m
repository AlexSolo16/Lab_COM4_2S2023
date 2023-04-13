clc;
clear;

%Generador de señal senoidal
fs = 500; %frecuencia de muestreo
t = 0:1/fs:1; %vector de tiempo
f = 100; % frecuencia de la señal
x = sin(2*pi*f*t); %señal senoidal

%Aplicar Transformada rapida de Fourier
xf = fft(x);

%Generer filtro pasa-bajo
n = length(x);
fcutoff = 50; %Frecuencia de corte
h = ones(n, 1); %vector de unos
h(round(n*fcutoff/fs)+1:end) = 0; %Aplicar filtro pasa-bajo

%Aplicar filtro a la señal en el dominio de la frecuencia
xf_filtered = xf .* h;

%Convertir señal filtrada a dominio del tiempo
x_filtered = ifft(xf_filtered);

%Graficas de la señal original y la señal filtrada
figure;
subplot(2, 1, 1);
plot(t, x);
title('Señal original');
xlabel('Tiempo (s)');
ylabel('Amplitud');
subplot(2, 1, 2);
plot(t, real(x_filtered));
title('Señal filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
