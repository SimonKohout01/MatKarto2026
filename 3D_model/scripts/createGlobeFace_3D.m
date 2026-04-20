function [] = createGlobeFace(uv, steps, R, uk, vk, s0, proj, conts, ub, vb)
    umin = uv(1,1);
    umax = uv(1,2); 
    vmin = uv(1,3); 
    vmax = uv(1,4);
    Du = steps(1,1);
    Dv = steps(1,2); 
    du = steps(1,3);
    dv = steps(1,4);

    hold on;
    


    [sb, db] = uvTosd(ub, vb, uk, vk);
    [XB, YB] = proj(R, sb, db, s0);
    
    % Create a 2d polygon object representing the exact shape of the face boundary
    polyBoundary = polyshape(XB, YB);
    
    % Convert the 2d boundary coordinates into 3d space based on the face orientation
    [XB3, YB3, ZB3] = to3D(XB, YB, R, uk, vk, ub, vb, XB, YB);
    
    % Draw a solid white 3d polygon to act as an opaque background for this face
    fill3(XB3, YB3, ZB3, 'w', 'EdgeColor', 'none', 'FaceAlpha', 1);

    % Generate the 2d grid lines for meridians (xm, ym) and parallels (xp, yp)
    [XM, YM, XP, YP] = graticule(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, s0, proj);
    
    % Find which points of the meridians lie inside the 2d pentagon boundary
    inM = inpolygon(XM, YM, XB, YB);
    
    % Replace the coordinates of points outside the boundary with NaN (not a number) so they won't be drawn
    XM(~inM) = NaN; YM(~inM) = NaN;
    
    % Find which points of the parallels lie inside the 2d pentagon boundary
    inP = inpolygon(XP, YP, XB, YB);
    
    % Replace the coordinates of points outside the boundary with nan
    XP(~inP) = NaN; YP(~inP) = NaN;
    
    % Convert the 2D clipped graticule coordinates into 3D space
    [XM3, YM3, ZM3] = to3D(XM', YM', R, uk, vk, ub, vb, XB, YB);
    [XP3, YP3, ZP3] = to3D(XP', YP', R, uk, vk, ub, vb, XB, YB);
    
    % Lift the graticule slightly (by 0.1%) away from the center to prevent Z-fighting
    XM3 = XM3 * 1.001; YM3 = YM3 * 1.001; ZM3 = ZM3 * 1.001;
    XP3 = XP3 * 1.001; YP3 = YP3 * 1.001; ZP3 = ZP3 * 1.001;
    
    % Draw the lifted 3D graticule lines in black
    plot3(XM3, YM3, ZM3, 'k', 'LineWidth', 0.2); 
    plot3(XP3, YP3, ZP3, 'k', 'LineWidth', 0.2);
   


    % continents
    fillColor = [39 93 31] / 255;
    edgeColor = [0 0 0] / 255;
    
% Loop through all the continents defined in the 'conts' list
    for i=1:length(conts)
        
        % Load the geographic coordinates of the continent and project them into 2d 
        [XC, YC] = drawContinent(conts{i}, R, uk, vk, s0, proj);
        
        % Create a 2d polygon object from the continent's coordinates
        polyCont = polyshape(XC, YC);
        
        % Clip the continent polygon using the pentagon face boundary (keep only what's inside)
        polyClipped = intersect(polyBoundary, polyCont);
        
        % Check if any part of the continent actually lies on this specific face
        if polyClipped.NumRegions > 0
            
            % continent fill
            % Break the complex clipped polygon down into a mesh of simple 2d triangles
            tr = triangulation(polyClipped); 
            
            % Extract the 2d coordinates of all the triangle vertices
            pts = tr.Points; 
            
           % Convert the triangulated continent fill into 3D space
            [XC3_tri, YC3_tri, ZC3_tri] = to3D(pts(:,1), pts(:,2), R, uk, vk, ub, vb, XB, YB);
            
            % Lift the continent fill by 0.2% so it renders clearly above the white face
            XC3_tri = XC3_tri * 1.002; YC3_tri = YC3_tri * 1.002; ZC3_tri = ZC3_tri * 1.002;
            
            % Draw the solid continent patches using the lifted coordinates
            patch('Faces', tr.ConnectivityList, 'Vertices', [XC3_tri, YC3_tri, ZC3_tri], ...
                  'FaceColor', fillColor, 'EdgeColor', 'none', 'FaceAlpha', 0.60);
                  
            % Extract the boundary vertices and convert them to 3D space
            bnd = polyClipped.Vertices;
            [XC3_bnd, YC3_bnd, ZC3_bnd] = to3D(bnd(:,1), bnd(:,2), R, uk, vk, ub, vb, XB, YB);
            
            % Lift the boundary lines by 0.3% so they render above both the face and the fill
            XC3_bnd = XC3_bnd * 1.003; YC3_bnd = YC3_bnd * 1.003; ZC3_bnd = ZC3_bnd * 1.003;
            
            % Draw the continent outlines using the highest lifted coordinates
            plot3(XC3_bnd, YC3_bnd, ZC3_bnd, 'Color', edgeColor, 'LineWidth', 0.35);
        end
    end
    % Edges visualize
    plot3(XB3, YB3, ZB3, 'k-', 'LineWidth', 2);
end

% We made these 3D models with help from AI and also from these MathWorks links. This task was very hard, so AI and these websites help me with explanation and how to do it in Matlab
% https://www.mathworks.com/help/matlab/2-and-3d-plots.html
% https://www.mathworks.com/help/releases/R2025b/matlab/ref/plot3.html
% https://www.mathworks.com/help/matlab/geometry.html