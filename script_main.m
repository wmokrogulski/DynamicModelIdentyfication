Ts=1e-2; % czas probkowania

non=1; % wlacznik szumu (1 gdy wlaczony)
namp=1e-7; % amplituda szumu
G=tf([1 2 1],[1 2 5 3]);
isstable(G);


[u_meas, y_meas]=measure_signals();
[Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,4);
[t, y_real, y_est,difference]=measure_difference();
difference_plots(1,[2 2],[1,2],'transmitancja 4 rzędu',t, y_real, y_est,difference);

[Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,3);
[t, y_real, y_est,difference]=measure_difference();
difference_plots(2,[2 2],[1,2],'transmitancja 3 rzędu',t, y_real, y_est,difference);

[Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,2);
[t, y_real, y_est,difference]=measure_difference();
difference_plots(3,[2 2],[1,2],'transmitancja 2 rzędu',t, y_real, y_est,difference);

[Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,1);
[t, y_real, y_est,difference]=measure_difference();
difference_plots(4,[2 2],[1,2],'transmitancja 1 rzędu',t, y_real, y_est,difference);

i=1;
for n=[1e-7 1e-6 1e-5 1e-4]
    namp=n;
    [u_meas, y_meas]=measure_signals();
    [Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,3);
    [t, y_real, y_est,difference]=measure_difference();
    difference_plots(i,[2 2],[3,4],'transmitancja 3 rzędu',t, y_real, y_est,difference);
    i=i+1;
end


function difference_plots(curr_plot_number, plot_number, figures, plot_title,t, y_real, y_est,difference)
figure(figures(1));
subplot(plot_number(1),plot_number(2),curr_plot_number);
plot(t,y_real, 'DisplayName', 'y_real');
hold on;
plot(t, y_est, 'DisplayName', 'y_est');
hold off;
legend('y_{real}','y_{est}');
grid minor;
xlabel('t [s]');
ylabel('y');
title(sprintf('%s - sygnały wyjściowe',plot_title));

figure(figures(2));
subplot(plot_number(1),plot_number(2),curr_plot_number);
plot(t,difference);
grid minor;
xlabel('t [s]');
ylabel('y');
title(sprintf('%s - różnica sygnałów',plot_title));
end

function [u_meas, y_meas]=measure_signals()
out=sim('model.slx'); % pobranie sygnalow z symulacji simulink
u_meas=out.u.data; % wymuszenie z symulacji 
y_meas=out.y.data; % wyjscie z symulacji
end

function [t, y_real, y_est,difference]=measure_difference()
out=sim('calc_diff.slx'); % pobranie sygnalow z symulacji simulink
t=out.y_real.time;
y_real=out.y_real.data; % wyjscie rzeczywiste z symulacji 
y_est=out.y_est.data; % wyjscie estymowane z symulacji
difference=out.difference.data;
end

function [Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas, rank_num)
Gd=c2d(G,Ts); % transmitancja dyskretna do sprawdzenia wyniku
A=[];
for i=1:rank_num
    A=[A, u_meas(i:end-rank_num+i-1)];
end
for i=1:rank_num
    A=[A, y_meas(i:end-rank_num+i-1)];
end
y=y_meas(1+rank_num:end);
x=pinv(A)*y;
num=[];
for i=1:rank_num
num=[num, x(rank_num+1-i)];
end
den=[1];
for i=1:rank_num
den=[den, -x(2*rank_num+1-i)];
end
Gdf=tf(num,den,Ts); % wyznaczona transmitancja dyskretna
Gf=d2c(Gdf); % wyznaczona transmitancja ciagla
end