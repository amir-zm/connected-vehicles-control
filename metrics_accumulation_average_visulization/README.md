# Accumulated Metrics and Visualization Module

This module calculates accumulated average metrics and visualizes the performance of a vehicle platoon under various Information Flow Topologies (IFTs) with shared control gains. Metrics include:
- **DRAC** (Deceleration Rate)
- **TTC** (Time-to-Collision)
- **InpuT** (Control Input Effort)
- **ACC** (Acceleration)
- **JRK** (Jerk)
- **Settling Time** per follower

## Overview

The module processes the previously computed control gains (via the shared control gains matrix `NC_common_tag`) along a 40×40 grid of gain parameters. It:
- Computes the scaling factors based on the number of grid points with shared control gains.
- Accumulates settling time values and computes per-vehicle metrics.
- Generates multiple figures that plot the cumulative metrics and their standard deviations over time.
- Aggregates the data into summary tables (mean ± standard deviation) for each metric.
- Computes the percentage of the area corresponding to different safety conditions.
- Saves the final results in a MAT-file (`last_result.mat`).

## Prerequisites

Before running this module, make sure that the following variables are available in your MATLAB workspace:
- `NC_common_tag` (40×40 matrix of shared control gains)
- `Tag_CGs` (control gains tags)
- `sampling_time_ini` (sampling time for integration)
- `tout` (time vector for impulse response analysis)
- `final_time_ini` (final simulation time)
- `follwers_num` (number of followers)
- `ift_num` (number of IFT configurations)
- Other variables produced by previous simulation modules (e.g., DRAC, TTC, InpuT, ACC, JRK, SetlTime)

Additionally, this module requires MATLAB’s Control System Toolbox.

## Code Structure

The code is modularized into a main function and several helper functions:

- **Main Function: `main_computeAccumulatedMetrics`**
  - Calls helper functions to initialize all necessary variables and arrays.
  - Iterates over vehicle indices (`kappa = 1:4`) and IFT configurations to:
    - Accumulate and compute settling times.
    - Plot per-vehicle metrics (DRAC, TTC, InpuT, ACC, JRK, and Settling Time).
  - Plots aggregated (mean and standard deviation) metrics per IFT.
  - Constructs summary tables (`TAbleDRAC`, `TAbleTTC`, `TAbleInpuT`, `TAbleACC`, `TAbleJRK`) in cell arrays.
  - Computes the area percentage of safe versus unsafe control gains.
  - Saves the final results in `last_result.mat`.

- **Helper Functions:**
  - **`initAccumulatedMetrics`** – Initializes constants, preallocates arrays, and defines plot settings.
  - **`plotPerVehicleMetrics`** – Processes the gain grid for each vehicle (indexed by `kappa`) and plots the per-vehicle metrics.
  - **`plotMeanStdIFT`** – Plots the cumulative mean and standard deviation for each metric over time, aggregated per IFT.
  - **`computeTAbleResults`** – Aggregates the results into summary tables (mean ± std) for each metric.
  - **`computeAreaPercentage`** – Computes the percentage area corresponding to safe control gains.
  
## How to Run

1. **Ensure Prerequisites:**  
   Run the previous simulation modules so that all necessary variables (e.g., `NC_common_tag`, `Tag_CGs`, `DRAC`, `TTC`, `InpuT`, `ACC`, `JRK`, `SetlTime`, `sampling_time_ini`, `tout`, etc.) are in the workspace.

2. **Execute the Module:**  
   In the MATLAB Command Window, simply run:
   ```matlab
   main_computeAccumulatedMetrics

