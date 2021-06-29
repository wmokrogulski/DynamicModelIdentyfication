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
title(sprintf('%s',plot_title));

figure(figures(2));
subplot(plot_number(1),plot_number(2),curr_plot_number);
plot(t,difference);
grid minor;
xlabel('t [s]');
ylabel('y');
title(sprintf('%s',plot_title));
end