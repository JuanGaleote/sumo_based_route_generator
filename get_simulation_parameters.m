function [Nped,Npas,Ts] = get_simulation_parameters(root)

% Counting pedestrians trips.

fid = fopen([root,'.pedestrian.trips.xml'],'r','n','UTF-8');
text = fread(fid, [1, Inf], '*char');
fclose(fid);

k = strfind(text,'<person');
Nped = str2double(extractBetween(text(k(end):end),'id="ped','"')) + 1;

% Counting passeger trips.

fid = fopen([root,'.passenger.trips.xml'],'r','n','UTF-8');
text = fread(fid, [1, Inf], '*char');
fclose(fid);

k = strfind(text,'<trip');
Npas = str2double(extractBetween(text(k(end):end),'id="veh','"')) + 1;

% Getting simulation time.

k1 = strfind(text,'<time>');
k2 = strfind(text,'</time');
T = str2double(extractBetween(text(k1:k2),'"','"'));
Ts = T(end) - T(1);

end

