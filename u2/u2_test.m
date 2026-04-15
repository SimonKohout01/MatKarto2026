clc
clear

%Conversion
u = [49, 50, 51] * pi / 180;
v = [14, 15, 16] * pi / 180;
uk = 60 * pi /180;
vk = 20 * pi / 180;

[s,d] = uvTosd(u, v, uk, vk);

%Draw graticule, gnomonic projection, normal aspect
umin = 20 * pi / 180;
umax = 90 * pi / 180;
vmin = -180 * pi / 180;
vmax = 180 * pi / 180;
Du = 10 * pi/180;
Dv = Du;
du = Du/10;
dv = Dv/10;
R = 1;
uk = 90*pi/180;
vk = pi/180;
u0 = pi/4;
proj = @gnom 

[XM, YM, XP, YP] = graticule(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, u0, proj);

hold on
axis equal
plot(XM', YM', 'k');
plot(XP', YP', 'k');

%Load and draw continents
R = 1;
uk = 90*pi/180;
vk = 0;
u0 = pi/4;
proj = @gnom
file = 'v:\Bayer\mk_2025_26\u2\continents_points\eur.txt'
[XC, YC] = drawContinent(file, R, uk, vk, u0, proj)
plot (XC, YC, 'b', 'LineWidth', 3)




