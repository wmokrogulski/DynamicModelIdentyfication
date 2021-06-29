function [u_meas, y_meas]=measure_signals()
out=sim('model.slx'); % pobranie sygnalow z symulacji simulink
u_meas=out.u.data; % wymuszenie z symulacji 
y_meas=out.y.data; % wyjscie z symulacji
end