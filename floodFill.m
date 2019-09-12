function [route,numExpanded] = floodFill(input_map, start_coords, dest_coords)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% set up color map for display
% 1 - white - clear cell
% 2 - black - obstacle
% 3 - red = visited
% 4 - blue  - on list
% 5 - green - start
% 6 - yellow - destination

cmap = [1 1 1; ...
        0 0 0; ...
        1 0 0; ...
        0 0 1; ...
        0 1 0; ...
        1 1 0; ...
	0.5 0.5 0.5];

colormap(cmap);

% variable to control if the map is being visualized on every
% iteration
drawMapEveryTime = true;

[nrows, ncols] = size(input_map);

% map - a table that keeps track of the state of each grid cell
map = zeros(nrows,ncols);

map(~input_map) = 1;   % Mark free cells
map(input_map)  = 2;   % Mark obstacle cells

start_node = sub2ind(size(map), start_coords(1), start_coords(2));
dest_node  = sub2ind(size(map), dest_coords(1),  dest_coords(2));

map(start_node) = 5;
map(dest_node)  = 6;

% Initialize distance array
distanceFromStart = Inf(nrows,ncols);

% For each grid cell this array holds the index of its parent
parent = zeros(nrows,ncols);

distanceFromStart(start_node) = 0;

% keep track of number of nodes expanded 
numExpanded = 0;

% Main Loop
while true

    % Draw current map
    map(start_node) = 5;
    map(dest_node) = 6;
    
       % make drawMapEveryTime = true if you want to see how the 
    % nodes are expanded on the grid. 
    if (drawMapEveryTime)
        image(1.5, 1.5, map);
        grid on;
        axis image;
        drawnow;
    end
    
    % Find the node with the minimum distance
    [min_dist, current] = min(distanceFromStart(:));
    
    if ((current == dest_node) || isinf(min_dist))
        break;
    end
    
    % Update map
    map(current) = 3;         % mark current node as visited
    distanceFromStart(current) = Inf; % remove this node from further consideration
    
    % Compute row, column coordinates of current node
    [i, j] = ind2sub(size(distanceFromStart), current);
    
        % Visit each neighbor of the current node and update the map, distances
    % and parent tables appropriately.
    n=[i+1,j;i-1,j;i,j+1;i,j-1;i-1,j-1;i+1,j-1;i-1,j+1;i+1,j+1];
    for k=1:8 
        if (n(k,1)>0 && n(k,1)<=nrows) && (n(k,2)>0 && n(k,2)<=ncols) && (map(n(k,1),n(k,2))~=2) && (map(n(k,1),n(k,2))~=3) && (map(n(k,1),n(k,2))~=4) && (map(n(k,1),n(k,2))~=5)
            map(n(k,1),n(k,2))=4;
            distanceFromStart(n(k,1),n(k,2))=min_dist+1;
            parent(n(k,1),n(k,2))=current;
        end
        
    end
     numExpanded = numExpanded+1;
end

%% Construct route from start to dest by following the parent links
if (isinf(distanceFromStart(dest_node)))
    route = [];
else
    route = [dest_node];
    
    while (parent(route(1)) ~= 0)
        route = [parent(route(1)), route];
    end
    
        % Snippet of code used to visualize the map and the path
    for k = 2:length(route) - 1        
        map(route(k)) = 7;
        pause(0.1);
        image(1.5, 1.5, map);
        grid on;
        axis image;
    end
end
end

