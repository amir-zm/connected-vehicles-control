## Pre-Platooning Initial Condition Generator
This MATLAB script simulates a pre-platooning phase in which a leader vehicle follows a piecewise trajectory (acceleration → cruise → deceleration), and follower vehicles respond based on basic tracking gains.

## Purpsoe
It outputs the initial conditions required to trigger full platooning.

## Key Features
- Models 1 leader + 4 follower vehicles (can be expanded)
- Uses symbolic closed-loop dynamics
- Flexible communication topology (see figure)
- Euler integration of pre-platooning dynamics
 
## After running `pre_platooning_initial_conditions.m`, you'll get:

- `Xreal_ini(:, :, plt_time)` — follower states at platoon start
- `xleader_ini(plt_time)` — leader position
- `vleader_ini(plt_time)` — leader velocity
- `aleader_ini(plt_time)` — leader acceleration

These values are to be used as initial conditions in the full platooning control simulation.

## Communication Topology
![Topology](figures/communication_topology.png
