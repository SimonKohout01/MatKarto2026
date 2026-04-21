clc
clear
close all


% List of continents
conts = {'continents_points/afr.txt', 'continents_points/afr_mad.txt', ...
         'continents_points/amer.txt', 'continents_points/antar.txt', ...
         'continents_points/austr.txt', 'continents_points/eur.txt', ...
         'continents_points/greenl.txt', 'continents_points/newzel1.txt', ...
         'continents_points/newzel2.txt', 'continents_points/tasm.txt'};


fig1 = figure('Color', 'w'); % White color for export

% Face 1: North pole (template from school)

ax1 = subplot(2, 3, 1); title('Face 01');
set(ax1, 'Color', 'w');     % White color for export

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

R = 6380;                   % Radius of the reference globe
scale = 1/150000000;        % Scale so it fits on A3
R = R * 100000 * scale;     % Scaled R in cm for export

lim = 1.2 * R;              % Limit of lenght of each subplot of a face

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
axis equal; hold on; axis off;
xlim([-lim, lim]); ylim([-lim, lim]);

% Face 2
ax2 = subplot(2, 3, 2); title('Face 02');
set(ax2, 'Color', 'w');

umin = -50 * pi / 180;
umax = 50 * pi / 180;
vmin = -50 * pi / 180;
vmax = 50 * pi / 180;

Du = 10 * pi/180;
Dv = Du;
du = pi/180;
dv = du;

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
axis equal; hold on;axis off;
xlim([-lim, lim]); ylim([-lim, lim]);


% Shortened notation for remaining faces - use with AI (to understand Matlab)

u_cut = 35.2644 * pi / 180; % Universal boundary angle for the cube
steps_short = [10*pi/180, 10*pi/180, pi/180, pi/180]; % Universal graticule steps

% Face 3

ax3 = subplot(2, 3, 3); title('Face 03');
set(ax3, 'Color', 'w');

uk = 0; vk = 90 * pi / 180; % Center shifted east by 90 degrees
uv = [-50*pi/180, 50*pi/180, 40*pi/180, 140*pi/180];

ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [45, 135, 135, 45, 45] * pi / 180;

createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on; axis off;
xlim([-lim, lim]); ylim([-lim, lim]);

% Face 4
ax4 = subplot(2, 3, 4); title('Face 04');
set(ax4, 'Color', 'w');

uk = 0; vk = 180 * pi / 180; % Center shifted east by 180 degrees
uv = [-60*pi/180, 60*pi/180, 120*pi/180, 240*pi/180];

ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [135, 225, 225, 135, 135] * pi / 180;

createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on; axis off;
xlim([-lim, lim]); ylim([-lim, lim]);
% Face 5
ax5 = subplot(2, 3, 5); title('Face 05');
set(ax5, 'Color', 'w');

uk = 0; vk = 270 * pi / 180; % Center shifted east by 270 degrees
uv = [-60*pi/180, 60*pi/180, 210*pi/180, 330*pi/180];

ub_vec = [u_cut, u_cut, -u_cut, -u_cut, u_cut];
vb_vec = [225, 315, 315, 225, 225] * pi / 180;

createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on; axis off;
xlim([-lim, lim]); ylim([-lim, lim]);



% Face 6: South pole
ax6 = subplot(2, 3, 6); title('Face 06');
set(ax6, 'Color', 'w');

uk = -90 * pi / 180; vk = 0; % Center at the South Pole
uv = [-90*pi/180, -30*pi/180, -pi, pi];

ub_vec = [-u_cut, -u_cut, -u_cut, -u_cut, -u_cut];
vb_vec = [-45, 45, 135, -135, -45] * pi / 180;

createGlobeFace(uv, steps_short, R, uk, vk, s0, proj, conts, ub_vec, vb_vec);
axis equal; hold on; axis off;
xlim([-lim, lim]); ylim([-lim, lim]);

print(gcf, 'hexahedron_faces.svg', '-dsvg', '-vector', '-r600'); % Export as svg file
