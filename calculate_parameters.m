function [Gdf, Gf]=calculate_parameters(G, Ts, u_meas,y_meas, rank_num)
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