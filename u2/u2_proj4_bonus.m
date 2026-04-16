clc
clear


% Bonus task: Validation of gnomonic projection using PROJ.
% PROJ string parameters: Official PROJ library documentation (proj.org)
% AI helped us to simplify the whole file and to make a correct format
% 

% Input parameters for the projection center and the tested point
% (Face 02 of the dodecahedron)
uk = 26.565051;             
vk = 0;                     
u = 40;                     
v = 15;                     

% MATLAB (R = 1)
% Function uvTosd rotates the globe so the center is at the pole
% Then we calculate the zenith distance (z) and project it to X and Y coordinates.
[s, d] = uvTosd(u * pi/180, v * pi/180, uk * pi/180, vk * pi/180);
z = pi/2 - s;                   
X_matlab = tan(z) * sin(d);          
Y_matlab = -tan(z) * cos(d);         

% Output results for the final report and terminal
fprintf('Matlab result for dodecahedron (Face 02):\n');
fprintf('X = %.6f\n', X_matlab);
fprintf('Y = %.6f\n', Y_matlab);

% Format the PROJ string for independent verification
% The sprintf function constructs text into a variable without printing it
% '%.6f' inserts our numbers (uk, vk) and rounds them to 6 decimal places
% '%%' is used to create a literal percent sign needed for the terminal format parameter
proj_str = sprintf('proj +proj=gnom +lat_0=%.6f +lon_0=%.6f +a=1 +b=1 -f "%%.6f"', uk, vk);

% '\n' represents a new line (Enter) and '%s' is the placeholder where our 'proj_str' variable is inserted
% Copy and paste the generated command into the OSGeo4W terminal for verification
% This terminal is part of the standard QGIS installation and is available to all QGIS users
fprintf('Command for the OSGeo4W terminal:\n%s\n', proj_str);

% Note
% After executing the command, the terminal will pause and wait for your input
% You must enter the test coordinates separated by a space in this exact order: 
% Longitude first, then Latitude (e.g. 15 40).


%Hexahedron

uk = 0;             
vk = 90;                     
u = 20;                     
v = 100;                     

[s, d] = uvTosd(u * pi/180, v * pi/180, uk * pi/180, vk * pi/180);
z = pi/2 - s;                   
X_matlab = tan(z) * sin(d);          
Y_matlab = -tan(z) * cos(d);         

fprintf('Matlab result for hexahedron (Face 03):\n');
fprintf('X = %.6f\n', X_matlab);
fprintf('Y = %.6f\n', Y_matlab);

proj_str = sprintf('proj +proj=gnom +lat_0=%.6f +lon_0=%.6f +a=1 +b=1 -f "%%.6f"', uk, vk);
fprintf('Command for the OSGeo4W terminal:\n%s\n', proj_str);



