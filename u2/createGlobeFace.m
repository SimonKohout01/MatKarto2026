function [] = createGlobeFace(uv, steps, R, uk, vk, s0, proj, conts, ub, vb)
    % Limits for graticule
    umin = uv(1,1);
    umax = uv(1,2); 
    vmin = uv(1,3); 
    vmax = uv(1,4);
    
    Du = steps(1,1); 
    Dv = steps(1,2); 
    du = steps(1,3); 
    dv = steps(1,4);

    
    hold on;
    axis equal;

    % Graticule (Draw grid lines)
    [XM, YM, XP, YP] = graticule(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, s0, proj);
    plot(XM', YM', 'k', 'LineWidth', 0.2); % Black color for grid
    plot(XP', YP', 'k', 'LineWidth', 0.2);

    % Continents - Fill with green color using loop - Help with AI to create 
    % a smart loop, so that we don't have to write code for each continent individually
    fillColor = [39 93 31] / 255;
    edgeColor = [39 93 31] / 255;
    
    % Use a loop to read and draw all continents from our list one by one,
    % conts are defiuned in u2
    for i=1:length(conts)
        [XC, YC] = drawContinent(conts{i}, R, uk, vk, s0, proj);
        
        % Using function fill t ocolor continents
        fill(XC, YC, fillColor, 'EdgeColor', edgeColor, 'LineWidth', 0.35, 'FaceAlpha', 0.20);
    end

    % Boundary - red cutting lines
    [sb, db] = uvTosd(ub, vb, uk, vk);
    [XB, YB] = proj(R, sb, db, s0);
    plot(XB, YB, 'r-', 'LineWidth', 0.5);
end