clc
clear

syms R u v

steps = 50;
format long g

%Gnomonic projection
x = R * tan(pi/2 - u) * cos(v);
y = R * tan(pi/2 - u) * sin(v);

%Partial derivatives
fu = diff(x, u);
fv = diff(x, v);
gu = diff(y, u);
gv = diff(y, v);

%Simplify
fu = simplify(fu, 'Steps', steps);
fv = simplify(fv, 'Steps', steps);
gu = simplify(gu, 'Steps', steps);
gv = simplify(gv, 'Steps', steps);

%Distortions
mp2 = (fu^2 + gu^2)/(R^2);
mr2 = (fv^2 + gv^2)/(R*cos(u))^2;
p = 2*(fu*fv + gu*gv)/(R*R*cos(u));

%Simplifications
mp2 = simplify(mp2, 'Steps', steps);
mr2 = simplify(mr2, 'Steps',steps);

%Angle beween projected meridian and parallel
num = gu*fv-fu*gv;
num = simplify(num, 'Steps',steps);
den = fu*fv + gu*gv;
den = simplify(den, 'Steps',steps);
fr = num/den;
fr = simplify(fr, 'Steps', steps);
omega = atan(fr);
omega = simplify(omega, 'Steps',steps);

%Area scale
P = num / (R^2*cos(u));
P = simplify(P, 'Steps',steps);

%Convergence
f = gu / fu;
f = simplify(f, "Steps",steps);
sigma = atan(f);
sigma = simplify(sigma,"Steps", steps);
conv = sigma - pi/2;

%Extreme azimuths
f = p / (mp2-mr2);
f = simplify(f,"Steps", steps);
A = 0.5*atan(f);

%Numerical computations
un = 35.2644 * pi/180;      % Vertice latitutde of hexahedron
vn = 45*pi/180;             % Vertice longitude
Rn = 6380;                  % RAdius for calculations

%Coordinates
xn = double(subs(x,{u,v,R},{un,vn,Rn}));
yn = double(subs(y,{u,v,R},{un,vn,Rn}));

%Local linear scales
mpn = sqrt(double(subs(mp2,{u,v,R},{un,vn,Rn})));
mrn = sqrt(double(subs(mr2,{u,v,R},{un,vn,Rn})));
pn = double(subs(p,{u,v,R},{un,vn,Rn}));

fprintf('Local linear scale of meridian (mp): %.6f\n', mpn);
fprintf('Local linear scale of parallel (mr): %.6f\n', mrn);

%Angle between meridian and prarallel
omegan = double(subs(omega,{u,v,R},{un,vn,Rn}));

%Area scale
Pn = double(subs(P,{u,v,R},{un,vn,Rn}));
fprintf('Area scale (P): %.6f\n', Pn);

%Convergence
convn = double(subs(conv,{u,v,R},{un,vn,Rn}));

%Extreme azimuths
A1 = 0;
A2 = pi/2;

%Maximum angular distortion
mad = 2*asin(abs(mpn - mrn)/(mpn + mrn));

% Semi axis of Tissot indicatrix
an = max(mpn, mrn);
bn = min(mpn, mrn);
fprintf('Semi axis of Tissot Indicatrix a: %.6f\n', an);
fprintf('Semi axis of Tissot Indicatrix b: %.6f\n', bn);

% Omega to ° ' "
if omegan < 0                       % If omega is lower than 0, add pi 
    omegan = omegan +pi;
end
omega_deg = floor(omegan*180/pi);   % Function floor rounds the value to the lower value, eg. 2,1 to 2
                                    % Also radians were converted to degrees
omega_min = floor((omegan*180/pi - omega_deg)*60);
omega_sec = ((omegan*180/pi - omega_deg)*60 - omega_min)*60;
fprintf('Omega'' of hexahedron in Q: %d° %02d'' %05.02f"\n', omega_deg, omega_min, omega_sec);

% Maximum angular distortion to ° ' "
mad_deg = floor(mad*180/pi);                    % Same idea as in omega above
mad_min = floor((mad*180/pi - mad_deg)*60);
mad_sec = ((mad*180/pi - mad_deg)*60 - mad_min)*60;
fprintf('MAD of hexahedron in Q: %d° %02d'' %05.02f"\n', mad_deg, mad_min, mad_sec);


% CREATING PLOT OF TISSOT INDICATRIX ON NORTHERN FACE FOR POINT Q
% AI helped here with some workflow and calculations 
scale = 1/1000000;
R = Rn * 100000 * scale;
uk = 90*pi/180; vk = 0; s0 = 0; proj = @gnom;

figure('Color', 'w'); title('Tissot Indicatrix of face 01 (HEXAHEDRON)')
hold on; axis equal; axis off;

umin = 30*pi/180; umax = 90*pi/180; vmin = 0; vmax = 360*pi/180;
Du = 10*pi/180; Dv = 10*pi/180; du = pi/180; dv = pi/180;
[XM, YM, XP, YP] = graticule(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, s0, proj);
plot(XM', YM', 'Color', 'black');
plot(XP', YP', 'Color', 'black');

% Drawing the boundary of one face of hexahedron for cutting (Square)
ub = [un, un, un, un, un];
vb = [-45, 45, 135, 225, 315] * pi/180; 
[sb, db] = uvTosd(ub, vb, uk, vk);
[xb, yb] = proj(R, sb, db, s0);
plot(xb, yb, 'r-', 'LineWidth', 1.5);

% Calculation of coordinates of the point Q
[sq, dq] = uvTosd(un, vn, uk, vk);
[Xq_map, Yq_map] = proj(R, sq, dq, s0); % Here is the centre of the ellipse

t = linspace(0, 2*pi); % Ellipse of 0°-360°
alpha = atan2(Yq_map, Xq_map); % Rotation of the ellipse so the longer axis lays on the meridian
scale_e = 150; % Scaling the ellipse (adjusted slightly for hexahedron so it fits nicely)

% Calculation of ellipse from calculated linear scales
xe = Xq_map + scale_e * (mpn * cos(t) * cos(alpha) - mrn * sin(t) * sin(alpha)); % Centre of ellipse + scale*(matrix of rotation)
ye = Yq_map + scale_e * (mpn * cos(t) * sin(alpha) + mrn * sin(t) * cos(alpha));

% Plotting the ellipse
plot(xe, ye, 'b-', 'LineWidth', 1.5); 

% Plotting the point Q
plot(Xq_map, Yq_map, 'ko', 'MarkerFaceColor', 'k');


% OPTIONAL TO EXPORT THE PLOT TO PDF
% print(gcf, 'tissot_hexahedron.pdf', '-dpdf'); % Export to PDF