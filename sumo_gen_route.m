function [receivers_routes, bbox_coordinates] = sumo_gen_route(filename,dT)

% Explanation of the function has to be here.
tic;

%% Initializing basic parameters.

root = strrep(filename,'.sumocfg','');                      % Routing name for all files.

% Obtaining number of every entity type for simulation.

[Ne,Ts] = get_simulation_parameters(root);

N = floor(Ts/dT);                                           % Total steps simulation.

%% Initializing SUMO tool with TraCI for MATLAB.

import traci.constants;             
traci.start(['sumo -c ',filename,' --start']);

% Initializing output variables.

receivers_routes = initialize_struct(N,Ne);                 % Output struct with the entities' routes.
bbox_coordinates = zeros(4,1);                              % Contains the boundaries from the traffic network.

%% Run simulation step by step.

bb = cell2mat(traci.simulation.getNetBoundary());           % Getting the boundaries in local coordinates.

[x,y] = traci.simulation.convertGeo(bb(1),bb(2));           % Converting down-left corner to geographical.
bbox_coordinates(1:2) = [y,x];

[x,y] = traci.simulation.convertGeo(bb(3),bb(4));           % Converting up-right corner to geographical.
bbox_coordinates(3:4) = [y,x];

for i = 1:N                               
    traci.simulation.step(i*dT);                            % Doing a simulation step.
    
    % Pedestrian analysis.
    
    list = traci.person.getIDList();                        % All pedestrian ID in actual time.
    Nped_act = length(list);                                % Total pedestrian number in actual time.
    
    for j = 1:Nped_act
        ped_id = cell2mat(list(j));                         % ID of the current pedestrian in analysis.
        
        pos = traci.person.getPosition(ped_id);             % Getting its position in local coordinates.
        [x,y] = traci.simulation.convertGeo(pos(1),pos(2)); % Converting them to geographical coordinates.
        pos = [y,x];                                        % Latitude-longitude pair.
        
        receivers_routes.pedestrians.(ped_id)(i,:) = pos;   % Saving coordinates for the current pedestrian.
    end
    
    % Passenger analysis.

    list = traci.vehicle.getIDList();                       % All vehicle ID in actual time.
    Npas_act = length(list);                                % Total vehicle number in actual time.
    
    for j = 1:Npas_act
        veh_id = cell2mat(list(j));                         % ID of the current vehicle in analysis.
        
        pos = traci.vehicle.getPosition(veh_id);            % Getting its position in local coordinates.
        [x,y] = traci.simulation.convertGeo(pos(1),pos(2)); % Converting them to geographical coordinates.
        pos = [y,x];                                        % Latitude-longitude pair.
        
        receivers_routes.vehicles.(veh_id)(i,:) = pos;      % Saving coordinates for the current pedestrian.
    end    
    
end

traci.close()
system('"C:\Windows\System32\taskkill.exe" /F /im cmd.exe &');
clc;

Te = toc;
fprintf('Elapsed time: %.2f min.\n',Te/60);
fprintf('Total entities departed: %d.\n',sum(Ne));

end

function entities_routes = initialize_struct(N,Ne)

% initialize_struct - Initialize the struct type for saving the entities
% routes. It has two fields called pedestrian and passenger. Which one of
% them has, also, many fields named with the corresponding entity content
% the pair latitude-longitude for it.

entities_routes = struct('pedestrians',struct(),'vehicles',struct());  

for i = 0:(Ne(1)-1)
    entities_routes.vehicles.(['veh',num2str(i)]) = NaN*zeros(N,2);
end

for i = 0:(Ne(2)-1)
    entities_routes.pedestrians.(['ped',num2str(i)]) = NaN*zeros(N,2);
end

for i = 0:(Ne(3)-1)
    entities_routes.vehicles.(['bike',num2str(i)]) = NaN*zeros(N,2);
end

for i = 0:(Ne(4)-1)
    entities_routes.vehicles.(['bus',num2str(i)]) = NaN*zeros(N,2);
end

for i = 0:(Ne(5)-1)
    entities_routes.vehicles.(['moto',num2str(i)]) = NaN*zeros(N,2);
end

for i = 0:(Ne(6)-1)
    entities_routes.vehicles.(['urban',num2str(i)]) = NaN*zeros(N,2);
end

for i = 0:(Ne(7)-1)
    entities_routes.vehicles.(['ship',num2str(i)]) = NaN*zeros(N,2);
end

for i = 0:(Ne(8)-1)
    entities_routes.vehicles.(['truck',num2str(i)]) = NaN*zeros(N,2);
end

end