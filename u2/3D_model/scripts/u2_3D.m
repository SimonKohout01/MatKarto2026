clc
clear

R = 1; 
proj = @gnom;
s0 = 0; 
Du = 10 * pi/180; 
Dv = 10 * pi/180; 
du = pi/180; dv = pi/180;
steps = [Du, Dv, du, dv];

% 3D
figure('Name', '3D Dodecahedron Globe', 'Color', 'w');
hold on;
axis equal;
view(3);
grid on;
rotate3d on;


% Coordinates of 12
% I took these exact latitude values directly from the manual
% For the south it is the same, we only change sign to minus 
u1_n = 26.5651 * pi/180; 
u1_s = -u1_n;
u2_n = 52.6226 * pi/180; 
u2_s = -u2_n;
u3_n = 10.8123 * pi/180; 
u3_s = -u3_n;

% Vertices A-E: North ring
Au = u2_n; 
Av = 0;
Bu = u2_n; 
Bv = 72*pi/180;
Cu = u2_n; 
Cv = 144*pi/180;
Du_v = u2_n; 
Dv_v = 216*pi/180;
Eu = u2_n;
Ev = 288*pi/180;


% Vertices F,H,J,L,N: Middle upper ring
% Manual for the task
Fu = u3_n; 
Fv = 0;          
Hu = u3_n;
Hv = 72*pi/180;  
Ju = u3_n; 
Jv = 144*pi/180; 
Lu = u3_n; 
Lv = 216*pi/180;    
Nu = u3_n; 
Nv = 288*pi/180;

% Vertices G,I,K,M,O: Middle below ring
Gu = u3_s; 
Gv = 36*pi/180;   
Iu = u3_s; 
Iv = 108*pi/180; 
Ku = u3_s;
Kv = 180*pi/180;  
Mu = u3_s; 
Mv = 252*pi/180;    
Ou = u3_s; 
Ov = 324*pi/180;

% Vertices P-T: Southern ring
Pu = u2_s; 
Pv = 36*pi/180;  
Qu = u2_s; 
Qv = 108*pi/180; 
Ru = u2_s; 
Rv = 180*pi/180; 
Su = u2_s; 
Sv = 252*pi/180;   
Tu = u2_s; 
Tv = 324*pi/180;

% List of continents

conts = {'continents_points/afr.txt', 'continents_points/afr_mad.txt', ...
         'continents_points/amer.txt', 'continents_points/antar.txt', ...
         'continents_points/austr.txt', 'continents_points/eur.txt', ...
         'continents_points/greenl.txt', 'continents_points/newzel1.txt', ...
         'continents_points/newzel2.txt', 'continents_points/tasm.txt'};


% Face 01
% Organize the plot into a 3x4 grid, select the first position
% subplot(3, 4, 1); title('Face 01');

% Define local graticule limits (40 to 90 degrees)
% uv = [umin, umax, vmin, vmax]
umin = 40*pi/180; 
umax = 90*pi/180; 
vmin = 0; 
vmax = 360*pi/180;
uv = [umin, umax, vmin, vmax];

% Set the cartographic pole
uk = 90*pi/180;
vk = 0;

% Define the cutting boundary using vertices A, B, C, D, E and back to A
ub = [Au, Bu, Cu, Du_v, Eu, Au];
vb = [Av, Bv, Cv, Dv_v, Ev, Av];

% Call the main drawing function
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Faces (02 - 12): 
% 1. uk, vk: The cartographic pole moves to the specific center of each pentagon
% 2. ub, vb: We select a new set of 5 vertices to define the cutting boundary
% 3. uv: We adjust local graticule limits to cover only the relevant area
% For these faces, we switch from normal to oblique transverse aspect

% AI helped us to rewrite our thoughts to matlab syntax and to describe the whole process
% It helped us save space by cleaning up the code so it looks neat on just a few lines 
% instead of being spread out, as can be seen in Faces 2–12, which are different from Face 1


% Face 02

umin = -20*pi/180; umax = 60*pi/180; vmin = -10*pi/180; vmax = 80*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_n; vk = Gv;
ub = [Au, Fu, Gu, Hu, Bu, Au]; vb = [Av, Fv, Gv, Hv, Bv, Av];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);


% Face 03

umin = -20*pi/180; umax = 60*pi/180; vmin = 60*pi/180; vmax = 150*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_n; vk = Iv;
ub = [Bu, Hu, Iu, Ju, Cu, Bu]; vb = [Bv, Hv, Iv, Jv, Cv, Bv];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 04

umin = -20*pi/180; umax = 60*pi/180; vmin = 140*pi/180; vmax = 220*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_n; vk = Kv;
ub = [Cu, Ju, Ku, Lu, Du_v, Cu]; vb = [Cv, Jv, Kv, Lv, Dv_v, Cv];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 05

umin = -20*pi/180; umax = 60*pi/180; vmin = 210*pi/180; vmax = 300*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_n; vk = Mv;
ub = [Du_v, Lu, Mu, Nu, Eu, Du_v]; vb = [Dv_v, Lv, Mv, Nv, Ev, Dv_v];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 06

umin = -20*pi/180; umax = 60*pi/180; vmin = 280*pi/180; vmax = 370*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_n; vk = Ov;
ub = [Eu, Nu, Ou, Fu, Au, Eu]; vb = [Ev, Nv, Ov, Fv, Av, Ev];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 07

umin = -60*pi/180; umax = 20*pi/180; vmin = 30*pi/180; vmax = 120*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_s; vk = Hv;
ub = [Hu, Gu, Pu, Qu, Iu, Hu]; vb = [Hv, Gv, Pv, Qv, Iv, Hv];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 08

umin = -60*pi/180; umax = 20*pi/180; vmin = 100*pi/180; vmax = 190*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_s; vk = Jv;
ub = [Ju, Iu, Qu, Ru, Ku, Ju]; vb = [Jv, Iv, Qv, Rv, Kv, Jv];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 09

umin = -60*pi/180; umax = 20*pi/180; vmin = 170*pi/180; vmax = 260*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_s; vk = Lv;
ub = [Lu, Ku, Ru, Su, Mu, Lu]; vb = [Lv, Kv, Rv, Sv, Mv, Lv];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 10

umin = -60*pi/180; umax = 20*pi/180; vmin = 240*pi/180; vmax = 330*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_s; vk = Nv;
ub = [Nu, Mu, Su, Tu, Ou, Nu]; vb = [Nv, Mv, Sv, Tv, Ov, Nv];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 11

umin = -60*pi/180; umax = 20*pi/180; vmin = 320*pi/180; vmax = 400*pi/180; uv = [umin, umax, vmin, vmax];
uk = u1_s; vk = Fv;
ub = [Fu, Ou, Tu, Pu, Gu, Fu]; vb = [Fv, Ov, Tv, Pv, Gv, Fv];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

% Face 12

umin = -90*pi/180; umax = -40*pi/180; vmin = 0; vmax = 360*pi/180; uv = [umin, umax, vmin, vmax];
uk = -90*pi/180; vk = 0;
ub = [Tu, Su, Ru, Qu, Pu, Tu]; vb = [Tv, Sv, Rv, Qv, Pv, Tv];
createGlobeFace_3D(uv, steps, R, uk, vk, s0, proj, conts, ub, vb);

