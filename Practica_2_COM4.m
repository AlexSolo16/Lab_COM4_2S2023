clc;
clear;

#Programa No.1
t = -0.04:0.001:0.04;
x = 20*exp(j*(80*pi*t-0.4*pi));
figure();
plot3(t, real(x), imag(x)); grid
title("20*e^{j*(80\pi*t-0.4\pi)}");
xlabel('Tiempo, s'); ylabel('Real'); zlabel('Imag')
figure();
plot(t, real(x), 'b'); hold on
plot(t, imag(x), 'r'); grid
title('Rojo - Componente Imaginario, Azul - Componente Real de la Exponencial')
xlabel('Tiempo'); ylabel('Amplitud')

#Programa No. 2
n = -1000:1000;
x = exp(j*2*pi*0.01*n);
figure()
plot(n, real(x), 'g');
title('Parte real x[n]');
y = exp(j*2*pi*2.01*n);
hold;
figure();
plot(n, real(y), 'r');
title('Parte real y[n]');

#Programa No. 3
n = -50:50;
x = cos(pi*0.1*n);
y = cos(pi*0.9*n);
z = cos(pi*2.1*n);
figure()
subplot(311);
plot(n, x);
title('x[n] = cos(0.1\pi*n)');
grid;
subplot(312);
plot(n, y);
title('y[n] = cos(0.9\pi*n)');
grid;
subplot(313);
plot(n, z);
grid;
title('z[n] = cos(2.1\pi*n)');
xlabel('n');

#Programa No. 4
n = -3:7;
x = 0.55 .^(n+3);
h = [1 1 1 1 1 1 1 1 1 1 1];
y = conv(x, h);
figure()
subplot(311);
stem(x);
title('Señal Original');
subplot(312);
stem(h);
title('Respuesta al Impulso / Segunda Señal');
subplot(313);
stem(y);
title('Convolucion resultante');



