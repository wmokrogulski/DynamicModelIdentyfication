%definiujemy transmitancje
mianownik = [1 2 1 3];
licznik = [1 2 1];
sys = tf(licznik, mianownik)
% wyznaczamyjej postać w dziedzinie czasu
syms s t
h = ilaplace(1/(1*s+10))
FT = tf(licznik,mianownik);                                           % Transfer Function Object                                                 % Invoke Symbolic Math Toolbox
snum = poly2sym(licznik, s)                                     % Symbolic Numerator Polynomial
sden = poly2sym(mianownik, s)                                     % Symbolic Denominator Polynomial
FT_time_domain = ilaplace(snum/sden)                        % Inverse Laplace Transform
FT_time_domain = simplify(FT_time_domain, 'Steps',10)       % Simplify To Get Nice Result
FT_time_domain = collect(FT_time_domain, exp(-t))           % Optional Further Factorization
% 15*exp(-10*t)
%ln(U) = ln(U0) - alfa * t
% odpowiedź na skok jednostkowy
figure;
step(sys);
% zapisanie danych
[dane, czas]=step(sys);
% usunięcie zera bo logarytm z zera daje minus nieskończoność :(
dane = dane(2:length(dane));
czas = czas(2:length(czas));

% mnk-nie działa nie wiem czemu
z = log(dane);
A = [ones(length(czas),1) czas];
xp = pinv(A)*z
U0=exp(xp(1))
alfa=xp(2)

U1 = U0*exp(alfa*czas);

figure;
scatter(czas,dane); %wykres punktowy
hold on
grid on
plot(czas,U1);

title('Dopasowanie zależności \it U(t)') 
xlabel('\it t [s]')
ylabel('\it U [V]')




% [A,B,C,D] = tf2ss(licznik, mianownik);


