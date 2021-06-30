%% inicjalizacja
close all;
clear;
clc;
Ts=1e-2; % okres probkowania

s_type=3; % 3 - skok, 2 - sinus, 1 - impuls prostokatny, 0 - impuls trojkatny
s_type_name='skok';
non=0; % wlacznik szumu (1 gdy wlaczony)
namp=1e-7; % amplituda szumu
G=tf([1 2 1],[1 2 5 3]);
if isstable(G)==0
    disp('uklad jest niestabilny')
    return
end
tf_file=fopen('transmitancje.txt','w');
ise_file=fopen('ise.txt','w');
for s_type=[3 2 1 0]
    for Ts=[1e-2, 1e-3, 1e-4]
        Gd=c2d(G,Ts); % transmitancja dyskretna do sprawdzenia wyniku
        switch s_type
            case 3
                s_type_name='skok';
            case 2
                s_type_name='sinus';
            case 1
                s_type_name='impuls prostokątny';
            case 0
                s_type_name='impuls trójkątny';
        end
        disp(s_type_name);
        fprintf(tf_file,'%s\n',s_type_name);
        fprintf(ise_file,'%s\n',s_type_name');
        fprintf(tf_file,'Ts=%.2g s\n',Ts);
        fprintf(ise_file,'Ts=%.2g s\n',Ts);



        % Wyznaczenie transmitancji roznych rzedow
        [u_meas, y_meas]=measure_signals();
        disp('transmitancja rzeczywista')
        fprintf(tf_file,'transmitancja rzeczywista\n');
        fprintf(tf_file,'transmitancja dyskretna\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gd));
        Gd
        fprintf(tf_file,'transmitancja ciągła\n');
        fprintf(tf_file,'%s\n',tf_to_latex(G));
        G
        disp('transmitancja 4-rzędu');
        fprintf(tf_file,'transmitancja 4-rzędu\n');
        fprintf(ise_file,'transmitancja 4-rzędu\n');

        [Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,4);
        [t, y_real, y_est,difference]=measure_difference();
        fprintf('ISE = %.2g\n',sum(difference.^2));
        fprintf(ise_file,'ISE = %.2g\n',sum(difference.^2));
        difference_plots(1,[2 2],[1,2],'transmitancja 4-rzędu',t, y_real, y_est,difference);
        fprintf(tf_file,'transmitancja dyskretna\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gdf));
        Gdf
        fprintf(tf_file,'transmitancja ciągła\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gf));
        Gf

        disp('transmitancja 3-rzędu');
        fprintf(tf_file,'transmitancja 3-rzędu\n');
        fprintf(ise_file,'transmitancja 3-rzędu\n');
        [Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,3);
        [t, y_real, y_est,difference]=measure_difference();
        fprintf('ISE = %.2g\n',sum(difference.^2));
        fprintf(ise_file,'ISE = %.2g\n',sum(difference.^2));
        difference_plots(2,[2 2],[1,2],'transmitancja 3-rzędu',t, y_real, y_est,difference);
        fprintf(tf_file,'transmitancja dyskretna\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gdf));
        Gdf
        fprintf(tf_file,'transmitancja ciągła\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gf));
        Gf

        disp('transmitancja 2-rzędu');
        fprintf(tf_file,'transmitancja 2-rzędu\n');
        fprintf(ise_file,'transmitancja 2-rzędu\n');
        [Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,2);
        [t, y_real, y_est,difference]=measure_difference();
        fprintf('ISE = %.2g\n',sum(difference.^2));
        fprintf(ise_file,'ISE = %.2g\n',sum(difference.^2));
        difference_plots(3,[2 2],[1,2],'transmitancja 2-rzędu',t, y_real, y_est,difference);

        fprintf(tf_file,'transmitancja dyskretna\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gdf));
        Gdf
        fprintf(tf_file,'transmitancja ciągła\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gf));
        Gf

        disp('transmitancja 1-rzędu');
        fprintf(tf_file,'transmitancja 1-rzędu\n');
        fprintf(ise_file,'transmitancja 1-rzędu\n');
        [Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,1);
        [t, y_real, y_est,difference]=measure_difference();
        fprintf('ISE = %.2g\n',sum(difference.^2));
        fprintf(ise_file,'ISE = %.2g\n',sum(difference.^2));
        difference_plots(4,[2 2],[1,2],'transmitancja 1-rzędu',t, y_real, y_est,difference);
        fprintf(tf_file,'transmitancja dyskretna\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gdf));
        Gdf
        fprintf(tf_file,'transmitancja ciągła\n');
        fprintf(tf_file,'%s\n',tf_to_latex(Gf));
        Gf


        % badanie dla roznych poziomow szumu
        i=1;
        non=1;
        for n=[1e-7 1e-6 1e-5 1e-4]
            namp=n;
            fprintf('transmitancja 3-rzędu\namp. szumu %.2g\n',namp)
            fprintf(ise_file,'transmitancja 3-rzędu\namp. szumu %.2g\n',namp);
            fprintf(tf_file,'transmitancja 3-rzędu\namp. szumu %.2g\n',namp);
            [u_meas, y_meas]=measure_signals();
            [Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas,3);
            fprintf(tf_file,'transmitancja dyskretna\n');
            fprintf(tf_file,'%s\n',tf_to_latex(Gdf));
            Gdf
            fprintf(tf_file,'transmitancja ciągła\n');
            fprintf(tf_file,'%s\n',tf_to_latex(Gf));
            Gf
            [t, y_real, y_est,difference]=measure_difference();
            fprintf('ISE = %.2g\n',sum(difference.^2));
            fprintf(ise_file,'ISE = %.2g\n',sum(difference.^2));
            difference_plots(i,[2 2],[3,4],sprintf('amp. szumu %.2g',namp),t, y_real, y_est,difference);

            i=i+1;
        end        
        cd 'obrazy/';
        fig=figure(1);
        sgtitle(sprintf('%s Ts = %.2g s porównanie odpowiedzi dla różnych transmitancji',s_type_name,Ts));
        set(fig, 'Position', get(0, 'Screensize'));
        saveas(fig,sprintf('%s_Ts_%.2g_por_odp_dla_transm.png',strrep(s_type_name,' ','_'),Ts))
        fig=figure(2);
        sgtitle(sprintf('%s Ts = %.2g s różnica sygnałów dla różnych transmitancji',s_type_name,Ts));
        set(fig, 'Position', get(0, 'Screensize'));
        saveas(fig,sprintf('%s_Ts_%.2g_roz_dla_transm.png',strrep(s_type_name,' ','_'),Ts))
        fig=figure(3);
        sgtitle(sprintf('%s Ts = %.2g s porównanie odpowiedzi dla różnych amplitud szumu (tr. 3-rzędu)',s_type_name,Ts));
        set(fig, 'Position', get(0, 'Screensize'));
        saveas(fig,sprintf('%s_Ts_%.2g_por_odp_dla_szumu.png',strrep(s_type_name,' ','_'),Ts))
        fig=figure(4);
        sgtitle(sprintf('%s Ts = %.2g s różnica sygnałów dla różnych amplitud szumu (tr. 3-rzędu)',s_type_name,Ts));
        set(fig, 'Position', get(0, 'Screensize'));
        saveas(fig,sprintf('%s_Ts_%.2g_por_roz_dla_szumu.png',strrep(s_type_name,' ','_'),Ts))
        cd '..';

    end
end

fclose(ise_file);
fclose(tf_file);
