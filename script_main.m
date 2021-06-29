%% inicjalizacja
Ts=1e-2; % okres probkowania

s_type=3; % 3 - skok, 2 - sinus, 1 - impuls prostokatny, 0 - impuls trojkatny
non=0; % wlacznik szumu (1 gdy wlaczony)
namp=1e-7; % amplituda szumu
G=tf([1 2 1],[1 2 5 3]);
if isstable(G)==0
    disp('uklad jest niestabilny')
    return
end

%% Wyznaczenie transmitancji roznych rzedow
[u_meas, y_meas]=measure_signals();
disp('transmitancja 4 rzędu');
[Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,4);
[t, y_real, y_est,difference]=measure_difference();
difference_plots(1,[2 2],[1,2],'transmitancja 4 rzędu',t, y_real, y_est,difference);

disp('transmitancja 3 rzędu');
[Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,3);
[t, y_real, y_est,difference]=measure_difference();
difference_plots(2,[2 2],[1,2],'transmitancja 3 rzędu',t, y_real, y_est,difference);
Gd
Gdf

disp('transmitancja 2 rzędu');
[Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,2);
[t, y_real, y_est,difference]=measure_difference();
difference_plots(3,[2 2],[1,2],'transmitancja 2 rzędu',t, y_real, y_est,difference);

disp('transmitancja 1 rzędu');
[Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,1);
[t, y_real, y_est,difference]=measure_difference();
difference_plots(4,[2 2],[1,2],'transmitancja 1 rzędu',t, y_real, y_est,difference);

%% badanie dla roznych poziomow szumu
i=1;
non=1;
for n=[1e-7 1e-6 1e-5 1e-4]
    namp=n;
    fprintf('transmitancja 3-rzędu\namp. szumu %g\n',namp)
    [u_meas, y_meas]=measure_signals();
    [Gd, Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,3);
    [t, y_real, y_est,difference]=measure_difference();
    difference_plots(i,[2 2],[3,4],sprintf('amp. szumu %g',namp),t, y_real, y_est,difference);
    
    i=i+1;
end
figure(3);
sgtitle('transmitancja 3-rzędu');
figure(4);
sgtitle('transmitancja 3-rzędu');
