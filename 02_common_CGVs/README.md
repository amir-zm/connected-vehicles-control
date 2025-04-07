# Shared Control Gains Computation

This repository contains MATLAB code for computing shared (common) control gains across various inter-follower topology (IFT) configurations. This module is intended to be run **after** executing the main simulation module that produces the `Tag_CGs` variable. The code compares the control gains tags across different IFT configurations and plots the gains that are common.

## Overview

The purpose of this module is to:
- **Compare** the control gains tag matrix (`Tag_CGs`) generated from the simulation module across multiple IFT configurations.
- **Determine** the common control gains by verifying where the tags remain identical.
- **Plot** the grid of control gains (denoted by gains `k` and `b`) using different colors for different common tag values.
  - **Blue markers:** Represent grid points where `common_tag` equals **2**.
  - **Green markers:** Represent grid points where `common_tag` equals **1**.
  - (Markers for tag values **3** and **4** are included in the code but currently commented out.)
- **Save** the resulting binary matrix (`NC_common_tag`), which indicates where the common control gains occur (i.e., where `common_tag` is either 1 or 2), into a MAT-file (`common_CGs.mat`).

## Prerequisites

Before running this module, ensure that:
- The simulation module has been executed and the variable `Tag_CGs` is available in your MATLAB workspace.
- The `Tag_CGs` variable is a 3D matrix (size 40x40xIFT configurations) containing control gains tags for each IFT configuration.

## Code Explanation

### 1. Initialization
- **Setting IFT Number:**  
  The variable `ift_num` is set to 9, meaning the code will compare 9 IFT configurations.
  
- **Equality Check Matrix (`eq_check`):**  
  A 40x40 matrix initialized with ones is used to iteratively check if the control gain tags in `Tag_CGs` are identical across consecutive IFT configurations.

### 2. Common Tag Calculation
- The code loops through the IFT configurations (except the last one) and updates `eq_check` by multiplying it with the result of element-wise comparison between consecutive slices of `Tag_CGs`.
- The `common_tag` matrix is computed as the element-wise product of the first slice of `Tag_CGs` and `eq_check`, which then represents the common control gains across the configurations.

### 3. Plotting the Shared Gains
- The code iterates over a 40×40 grid, where each grid cell corresponds to a pair of control gains:
  - `k = (kt-1)*0.5 + 0.1`
  - `b = (bt-1)*0.5 + 0.1`
- Based on the value of `common_tag` at each grid point:
  - **If `common_tag == 2`**: a blue marker is plotted.
  - **If `common_tag == 1`**: a green marker is plotted.
  - Plot commands for values **3** and **4** are present but commented out.
- This results in a visualization of the control gains that are shared across configurations.

### 4. Saving the Common Control Gains Data
- A binary matrix `NC_common_tag` is computed, where a value of 1 indicates that the corresponding grid point in `common_tag` is either 1 or 2.
- The variable `NC_common_tag` is saved to a file called `common_CGs.mat` for further analysis or record-keeping.

## How to Run

1. **Run the Main Simulation Module:**  
   Ensure you have executed the simulation module that outputs the `Tag_CGs` variable.

2. **Run this Module:**  
   Execute the script (e.g., save as `commonControlGains.m`) in MATLAB:
   ```matlab
   commonControlGains

