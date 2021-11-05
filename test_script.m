clear all; close all; clc;

[receivers_routes, bb, Ntot] = sumo_gen_route('./testing_map2/osm.sumocfg',20);

fieldnames1 = fieldnames(receivers_routes.pedestrians);
fieldnames2 = fieldnames(receivers_routes.vehicles);
figure();
hold on;
for i = 1:length(fieldnames1)
   plot(receivers_routes.pedestrians.(cell2mat(fieldnames1(i)))(:,2),receivers_routes.pedestrians.(cell2mat(fieldnames1(i)))(:,1)); 
end
for i = 1:length(fieldnames2)
   plot(receivers_routes.vehicles.(cell2mat(fieldnames2(i)))(:,2),receivers_routes.vehicles.(cell2mat(fieldnames2(i)))(:,1)); 
end
hold off;