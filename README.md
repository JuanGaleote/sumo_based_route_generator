# sumo_based_route_generator

A soft package developed in MATLAB for generating real traffic routes for pedestrian, cars, bikes, trucks... based on SUMO simulator from Eclipse.
Needed to be install before using:
  - The SUMO software (https://www.eclipse.org/sumo/).
  - The tool TraCi for MATLAB (https://github.com/pipeacosta/traci4matlab).

It can be used for general purpose but, in fact, it has been developed for route generation for a 5G mobility analysis tool simulation, also developed in MATLAB.

### USING ####

Previoulsy, generate a traffic network with SUMO (the best way is to use the OSM Web Wizard tool included with the software) adding all the vehicles and pedestrian parameters you want in. When you generate the file, you have to call the master function _sumo_gen_route(filename,dT)_ whose input parameters are the .sumocfg file and the step time (in seconds) simulation. It returns to you three outputs: an struct type with all the geographical coordinates in time for each pedestrian and vehicle, the bounding box coordinates of the network and the total departed entities in the simulation.

### RELEASE 1.0 DETAILS ###

- Import Public Transport option from OSM Web Wizard tool has not support, so please don't mark it when generate traffic networks.
