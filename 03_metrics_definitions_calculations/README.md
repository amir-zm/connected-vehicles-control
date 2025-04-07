# Metrics Computation Module for Shared Control Gains

This module computes various performance metrics for different Information Flow Topologies (IFTs) under shared control gains. It evaluates key safety and performance measures such as DRAC (Deceleration Rate), TTC (Time-to-Collision), InpuT (Input effort), ACC (Acceleration), JRK (Jerk), and settling time for a platoon of vehicles. These metrics help assess the quality and safety of the control strategies applied to the vehicle platoon.

## Overview

The module is designed to be executed after the simulation modules that generate shared control gains (via the `NC_common_tag` variable). It:
- Sets up environmental and vehicle parameters as parallel constants.
- Preallocates arrays to store metric data across time, gain grid dimensions, IFT configurations, and followers.
- Computes dynamic responses using transfer function analysis.
- Evaluates performance metrics by processing impulse responses from the system output.
- Saves the computed metric arrays to a MAT-file for further analysis or plotting.

## Prerequisites

Before running the metrics computation module, ensure that:
- The shared control gains simulation has been executed and produced the following variables:
  - `NC_common_tag` – a 40×40 matrix indicating grid locations with shared control gains.
  - `Tag_CGs`, `IC`, `tau`, `Uii`, `vel_def1`, `pos_def1`, `acc_def1`, `varrho_t_iip`, `nu_t_iip`, etc.
- The time vector `tout` (used for impulse response computation) is available.
- MATLAB’s Control System Toolbox is installed (for creating transfer functions and computing impulse responses).

## Code Structure

The module is organized into a main function and several helper functions:

- **Main Function: `main_computeMetrics`**
  - Initializes environmental and vehicle parameters (e.g., air density, mass, cross-sectional area, drag coefficients).
  - Preallocates arrays for storing metrics.
  - Iterates over each IFT configuration and gain grid point.
  - For grid points satisfying the shared control gains condition (`NC_common_tag`), computes:
    - Transfer function–based system gains.
    - The Q matrix and error metrics (Theta, Gamma, Lambda, Psi).
    - Impulse responses and state vectors.
    - Performance metrics (DRAC, TTC, InpuT, ACC, JRK, and settling time).
  - Saves the computed data into a file named `03_Safe&Unsafe_CCGs_4Plot.mat`.

- **Helper Functions:**
  - **`createParallelConstant`** – Wraps constants for parallel processing.
  - **`initMetricArrays` & `initTempArrays`** – Preallocate arrays for metric storage.
  - **`computeGainsMetrics`** – Computes transfer function–based gains and related arrays.
  - **`computeQMatrix`** – Constructs the Q matrix based on current control gains.
  - **`computeErrorMetrics`** – Evaluates error-related variables (Theta, Gamma, Lambda, Psi).
  - **`formXtilda`** – Forms the state vector from position, velocity, and acceleration outputs.
  - **`computeImpulseResponses`** – Computes impulse responses for each follower.
  - **`computeSetlTime`, `computeTTC`, `computeDRAC`** – Compute individual metrics for settling time, TTC, and DRAC.
  - **`computePKKplusMetrics`** – Aggregates terms required for InpuT, JRK, and ACC metrics.

## How to Run

1. **Prepare Prerequisites:**  
   Ensure that the simulation modules have been executed and that all prerequisite variables (e.g., `NC_common_tag`, `IC`, `tau`, `tout`, etc.) are present in the workspace.

2. **Execute the Module:**  
   In MATLAB, run:
   ```matlab
   main_computeMetrics

