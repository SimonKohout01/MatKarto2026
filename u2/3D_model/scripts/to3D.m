function [X, Y, Z] = to3D(x, y, R, uk, vk, ub, vb, XB, YB)
    % Helper function: conversion of 2d gnomonic coordinates to 3d dodecahedron space
    
    % Calculate the absolute 3d center of the current face
    % Using standard spherical to cartesian coordinate conversion formulas
    C = [R*cos(uk)*cos(vk), R*cos(uk)*sin(vk), R*sin(uk)];
    
    % Find the exact 3d position of the first two face boundary vertices on the sphere
    B1 = [R*cos(ub(1))*cos(vb(1)), R*cos(ub(1))*sin(vb(1)), R*sin(ub(1))];
    B2 = [R*cos(ub(2))*cos(vb(2)), R*cos(ub(2))*sin(vb(2)), R*sin(ub(2))];
    
    % Project these 3d vertices onto the tangent plane of the dodecahedron
    % This stretches the points from the spherical surface onto the flat 3d face
    T1 = B1 * (R^2 / dot(B1, C));
    T2 = B2 * (R^2 / dot(B2, C));
    
    % Determine the 3d directional vectors from the face center to these two vertices
    d1 = T1 - C;
    d2 = T2 - C;
    
    % Create a system matrix using the known 2d local coordinates of the vertices
    M = [XB(1), YB(1); XB(2), YB(2)];
    
    % If the matrix determinant is close to zero (meaning points are in a line),
    % Use the third vertex instead to ensure we can solve the equation
    if abs(det(M)) < 1e-6
        B3 = [R*cos(ub(3))*cos(vb(3)), R*cos(ub(3))*sin(vb(3)), R*sin(ub(3))];
        T3 = B3 * (R^2 / dot(B3, C));
        d2 = T3 - C;
        M = [XB(1), YB(1); XB(3), YB(3)];
    end
    
    % Calculate the local axes (vx, vy) in 3d space and normalize them
    % This solves the linear equation system to find exactly where the local x and y axes point
    V = M \ [d1; d2];
    Vx = V(1, :) / norm(V(1, :));
    Vy = V(2, :) / norm(V(2, :));
    
    % Apply the transformation to all input 2d data points
    % Places every 2d point exactly into the 3d space using the center and local axes
    X = C(1) + x .* Vx(1) + y .* Vy(1);
    Y = C(2) + x .* Vx(2) + y .* Vy(2);
    Z = C(3) + x .* Vx(3) + y .* Vy(3);
end


% We made these 3D models with help from AI and also from these MathWorks links. This task was very hard, so AI and these websites help me with explanation and how to do it in Matlab
% https://www.mathworks.com/help/matlab/2-and-3d-plots.html
% https://www.mathworks.com/help/releases/R2025b/matlab/ref/plot3.html
% https://www.mathworks.com/help/matlab/geometry.html