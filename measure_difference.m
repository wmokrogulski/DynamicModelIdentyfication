function [t, y_real, y_est,difference]=measure_difference()
out=sim('calc_diff.slx'); % pobranie sygnalow z symulacji simulink
t=out.y_real.time;
y_real=out.y_real.data; % wyjscie rzeczywiste z symulacji 
y_est=out.y_est.data; % wyjscie estymowane z symulacji
difference=out.difference.data;
end