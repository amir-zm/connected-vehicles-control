# IFT Control System Simulation

This repository contains a MATLAB simulation code for analyzing follower dynamics under different inter-follower topologies (IFT). The simulation computes control gains and evaluates the stability and performance of a platoon of follower vehicles using various configurations. The code is modularized into several functions for easier maintenance and testing.

## Overview

The simulation models a formation control problem where the dynamics of follower vehicles are analyzed using state-space models and transfer functions. For each configuration (IFT), the code:
- Configures the interconnection matrix (`IC`).
- Generates a grid of controller gains.
- Computes initial differences in positions, velocities, and accelerations.
- Evaluates system response via transfer function analysis.
- Updates real-time plots using a DataQueue and a dedicated `updatePlot` function.

## Prerequisites

Before running the simulation, ensure that the following prerequisite data is available in your MATLAB workspace:
- `vleader_ini`: Initial velocity data of the leader.
- `plt_time`: Time index or simulation time step.
- `sp`: Safe distance or desired spacing.
- `Xreal_ini`: Initial state information for the vehicles.
- `omegatout`: Parameter used in computing differences.
- `aleader_ini`: Leader acceleration data.

The simulation also requires the MATLAB Control System Toolbox (for transfer function definitions with `tf`).

## Code Structure

### Main Function: `main_CGVs_classifier.m`

- **main_CGVs_classifier**  
  - **Setup:** Clears the workspace, closes figures, and prompts the user to input the number of followers (4, 6, 8, or 10).
  - **Preallocations:** Initializes matrices for interconnection configuration (`IC`), controller gains grid (`kb_grid`), and response storage (`Tag_CGs`, etc.).
  - **System Parameters:** Defines system constants, transfer functions, and other parameters (e.g., `sd`, `T_1`, `Uii`).
  - **Configuration:** Calls helper functions to configure `IC`, compute row sums, generate the gains grid, define control parameters (`tau`), and compute initial differences.
  - **Parallel Computation:** Uses parallel loops (with `parfor`) to compute intermediate variables (`varrho_t_iip` and `nu_t_iip`).
  - **Simulation Loop:** Runs the main simulation loop where the system response is computed and stability is checked. Plots are updated in real time using a DataQueue.
  - **Output:** Saves simulation results and figures.

### Helper Functions

- **configureIC.m**  
  Configures the interconnection matrix (`IC`) for each IFT case based on the number of followers.

- **computeRowSum.m**  
  Computes the row sum for the `IC` matrix for each IFT configuration.

- **computeKBGrid.m**  
  Constructs the grid of controller gains (`k` and `b` values) used in the simulation.

- **defineTau.m**  
  Defines the control parameter vector (`tau`) based on the number of followers.

- **computeDifferences.m**  
  Computes the initial differences in position, velocity, and acceleration using prerequisite variables.

- **computeVarNu.m**  
  Computes intermediate variables (`varrho_t_iip` and `nu_t_iip`) needed for response computation. This function uses parallel computing to speed up processing.

- **runSimulationLoop.m**  
  The core simulation loop that:
  - Iterates through each IFT configuration.
  - Computes system matrices and checks stability (using eigenvalues).
  - Plots the results, adjusting subplot positions as needed.
  - Uses a parallel loop to compute responses for each gain combination.

- **adjustSubplot.m**  
  Adjusts the subplot layout to enhance visualization.

- **computeResponse.m & computeResponse_A.m**  
  Compute the system response (acceleration, velocity, and position outputs) based on the current controller gains and system matrices.

- **updatePlot.m**  
  Updates the real-time plot using a DataQueue. The function uses different marker colors to indicate performance:
  - **Red:** Indicates a response where certain performance thresholds (e.g., impulse responses) are not met.
  - **Blue:** Indicates another performance condition.
  - **Green:** Indicates acceptable performance.
  The plot is formatted with axis labels, ticks, and titles corresponding to the IFT configuration.

## How to Run

1. **Prepare the Prerequisites:**
   First run pre_platooning_initial_conditions.m in initializer folder  
   To load all prerequisite variables (such as `vleader_ini`, `plt_time`, `sp`, `Xreal_ini`, `omegatout`, and `aleader_ini`) in your MATLAB workspace.

2. **Run the Simulation:**  
   In the MATLAB Command Window, simply type:
   ```matlab
   main_CGVs_classifier

