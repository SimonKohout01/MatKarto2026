clc
clear
close all


% List of continents
conts = {'continents_points/afr.txt', 'continents_points/afr_mad.txt', ...
         'continents_points/amer.txt', 'continents_points/antar.txt', ...
         'continents_points/austr.txt', 'continents_points/eur.txt', ...
         'continents_points/greenl.txt', 'continents_points/newzel1.txt', ...
         'continents_points/newzel2.txt', 'continents_points/tasm.txt'};


% Face 1: North pole (template from school)

subplot(2, 3, 1);

% Graticule limits (latitude and longitude bounds)
umin = 30 * pi / 180;
umax = 90 * pi / 180;
vmin = -180 * pi / 180;
vmax = 180 * pi / 180;

% Step sizes for the graticule grid rendering
Du = 10 * pi/180;
Dv = Du;
du = pi/180;
dv = du;

R = 1;              % Radius of the reference globe
uk = 90 * pi/180;   % Latitude of the projection center (North Pole)
vk = 0;             % Longitude of the projection center
u0 = pi/4;          % Standard parallel (legacy parameter)
proj = @gnom;       % Function handle for gnomonic projection formulas

% Array containing graticule step parameters required by the function
steps = [Du, Dv, du, dv]; 
s0 = 0.1;           % Plotting resolution parameter

% Definition of the square clipping boundaries for the cube
% 35.2644 deg is the critical angle for a circumscribed cube (arcsin(1/sqrt(3)))
ub = 35.2644 * pi/180; 
vb1 = -45 * pi/180;
vb2 = 45 * pi/180;
vb3 = 135 * pi/180;
vb4 = -135 * pi/180;

uv = [umin, umax, vmin, vmax];

% Combine individual corners into a closed polygon vector for the boundary clip
ub_vec = [ub, ub, ub, ub, ub];
vb_vec = [vb1, vb2, vb3, vb4, vb1];

% Generate and plot the face, map network, and continents
createGlobeFace(uv, steps, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on;


% Face 2
subplot(2, 3, 2);

umin = -45 * pi / 180;
umax = 45 * pi / 180;
vmin = -45 * pi / 180;
vmax = 45 * pi / 180;

Du = 10 * pi/180;
Dv = Du;
du = pi/180;
dv = du;

R = 1;
uk = 0;             % Latitude of the projection center (Equator)
vk = 0;             % Longitude of the projection center (Prime Meridian)
u0 = pi/4;
proj = @gnom; 

steps = [Du, Dv, du, dv];
s0 = 0.1;

ub = 35.2644 * pi/180;
vb1 = -45 * pi/180;
vb2 = 45 * pi/180;
vb3 = 45 * pi/180;
vb4 = -45 * pi/180;

uv = [umin, umax, vmin, vmax];

% For equatorial faces, the latitude boundary alternates (top and bottom edges)
ub_vec = [ub, ub, -ub, -ub, ub];
vb_vec = [vb1, vb2, vb3, vb4, vb1];

createGlobeFace(uv, steps, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on;



% Shortened notation for remaining faces - use with AI (to understand Matlab)

u_cut = 35.2644 * pi / 180; % Universal boundary angle for the cube
steps_short = [10*pi/180, 10*pi/180, pi/180, pi/180]; % Universal graticule steps

% Face 3

subplot(2, 3, 3);
uk = 0; vk = 90 * pi / 180; % Center shifted east by 90 degrees
uv = [-45*pi/180, 45*pi/180, 45*pi/180, 135*pi/180];

ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [45, 135, 135, 45, 45] * pi / 180;

createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on;


% Face 4
subplot(2, 3, 4);
uk = 0; vk = 180 * pi / 180; % Center shifted east by 180 degrees
uv = [-45*pi/180, 45*pi/180, 135*pi/180, 225*pi/180];

ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [135, 225, 225, 135, 135] * pi / 180;

createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on;

% Face 5
subplot(2, 3, 5);
uk = 0; vk = 270 * pi / 180; % Center shifted east by 270 degrees
uv = [-45*pi/180, 45*pi/180, 225*pi/180, 315*pi/180];

ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [225, 315, 315, 225, 225] * pi / 180;

createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on;




% Face 6: South pole
subplot(2, 3, 6);
uk = -90 * pi / 180; vk = 0; % Center at the South Pole
uv = [-90*pi/180, -30*pi/180, -pi, pi];

ub_vec = [-u_cut, -u_cut, -u_cut, -u_cut, -u_cut];
vb_vec = [-45, 45, 135, -135, -45] * pi / 180;

createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on;

print(gcf, 'hexahedron_faces.svg', '-dsvg'); % Export as svg file