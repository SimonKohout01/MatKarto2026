clc
clear
close all

% List of continents
conts = {'continents_points/afr.txt', 'continents_points/afr_mad.txt', ...
         'continents_points/amer.txt', 'continents_points/antar.txt', ...
         'continents_points/austr.txt', 'continents_points/eur.txt', ...
         'continents_points/greenl.txt', 'continents_points/newzel1.txt', ...
         'continents_points/newzel2.txt', 'continents_points/tasm.txt'};

% --- INICIALIZACE 3D SCÉNY ---
figure('Name', '3D Polyedricky Globus - Sestisten', 'Color', 'w');
hold on;
axis equal;
view(3); % Nastavení 3D pohledu
grid on;
rotate3d on; % Povolí otáčení myší

R = 1;              % Radius of the reference globe
proj = @gnom;       % Function handle for gnomonic projection formulas

% =========================================================================

% Face 1: North pole
umin = 30 * pi / 180; umax = 90 * pi / 180;
vmin = -180 * pi / 180; vmax = 180 * pi / 180;
Du = 10 * pi/180; Dv = Du; du = pi/180; dv = du;
uk = 90 * pi/180; vk = 0; s0 = 0.1;

ub = 35.2644 * pi/180; 
vb1 = -45 * pi/180; vb2 = 45 * pi/180; vb3 = 135 * pi/180; vb4 = -135 * pi/180;

uv = [umin, umax, vmin, vmax];
steps = [Du, Dv, du, dv]; 
ub_vec = [ub, ub, ub, ub, ub];
vb_vec = [vb1, vb2, vb3, vb4, vb1];

% Přidán parametr face_id = 1
createGlobeFace(uv, steps, R, uk, vk, s0, proj, conts, ub_vec, vb_vec, 1);

% =========================================================================

% Face 2: Equator (Front)
umin = -45 * pi / 180; umax = 45 * pi / 180;
vmin = -45 * pi / 180; vmax = 45 * pi / 180;
uk = 0; vk = 0;
uv = [umin, umax, vmin, vmax];
ub_vec = [ub, ub, -ub, -ub, ub];
vb_vec = [vb1, vb2, vb3, vb4, vb1];

% Přidán parametr face_id = 2
createGlobeFace(uv, steps, R, uk, vk, s0, proj, conts, ub_vec, vb_vec, 2);

% =========================================================================
% Společné parametry pro zbylé stěny
u_cut = 35.2644 * pi / 180; 
steps_short = [10*pi/180, 10*pi/180, pi/180, pi/180]; 

% Face 3: Equator (Right)
uk = 0; vk = 90 * pi / 180;
uv = [-45*pi/180, 45*pi/180, 45*pi/180, 135*pi/180];
ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [45, 135, 135, 45, 45] * pi / 180;
createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec, 3);

% =========================================================================

% Face 4: Equator (Back)
uk = 0; vk = 180 * pi / 180;
uv = [-45*pi/180, 45*pi/180, 135*pi/180, 225*pi/180];
ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [135, 225, 225, 135, 135] * pi / 180;
createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec, 4);

% =========================================================================

% Face 5: Equator (Left)
uk = 0; vk = 270 * pi / 180;
uv = [-45*pi/180, 45*pi/180, 225*pi/180, 315*pi/180];
ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [225, 315, 315, 225, 225] * pi / 180;
createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec, 5);

% =========================================================================

% Face 6: South pole (Bottom)
uk = -90 * pi / 180; vk = 0;
uv = [-90*pi/180, -30*pi/180, -pi, pi];
ub_vec = [-u_cut, -u_cut, -u_cut, -u_cut, -u_cut];
vb_vec = [-45, 45, 135, -135, -45] * pi / 180;
createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec, 6);

% =========================================================================
% OŘÍZNUTÍ PŘESAHŮ (Nahrazuje původní masku z 2D)
% Omezíme 3D osy přesně na velikost naší krychle (-R až R).
% Cokoliv přesahuje, MATLAB ve 3D okně prostě nevykreslí.

xlim([-R R]);
ylim([-R R]);
zlim([-R R]);

% Nakreslení nenápadného boxu, který zvýrazní tvar krychle
set(gca, 'BoxStyle', 'full', 'Box', 'on');