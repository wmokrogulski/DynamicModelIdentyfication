Ts=0.01;
non=0; % wlacznik szumu (1 gdy wlaczony)
namp=5e-3; % amplituda szumu

G=tf([1],[1 1])

Gd=c2d(G,Ts)
out=sim('model.slx');
y_meas=out.y.data;
u_meas=out.u.data; % wymuszenie z symulacji 

A=[y_meas(1:end-1),u_meas(1:end-1)];
y=y_meas(2:end);
x=pinv(A)*y;
Gd=tf([x(2)],[1 -x(1)],Ts)
Gfinal=d2c(Gd)