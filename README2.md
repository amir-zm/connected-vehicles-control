
Each module is written in a modular style to facilitate testing, maintenance, and future extensions. Detailed comments and helper functions are provided within each file for clarity.

## Prerequisites

Before running the modules, ensure that you have MATLAB installed (R20xx or later recommended) along with the Control System Toolbox. Also, load or compute the following prerequisite variables in your workspace:
- **Simulation Data:**  
  `vleader_ini`, `plt_time`, `Xreal_ini`, `omegatout`, `aleader_ini`
- **Metric Analysis:**  
  `tout`, `sampling_time_ini`, `final_time_ini`
- **Intermediate Variables:**  
  `Tag_CGs`, `NC_common_tag`, `IC`, `tau`, `Uii`, `vel_def1`, `pos_def1`, `acc_def1`, `varrho_t_iip`, `nu_t_iip`, etc.

## How to Run

1. **IFT Control System Simulation:**
   - Run `runSimulation.m` from the MATLAB command window.
   - When prompted, enter the number of followers (e.g., 4, 6, 8, or 10).
   - The simulation will execute, update plots in real time using `updatePlot.m`, and save the results.

2. **Shared Control Gains:**
   - After the simulation, run `commonControlGains.m` to compute and visualize the shared control gains.
   - This module processes the simulation output (stored in `Tag_CGs`) and generates a gain grid visualization.

3. **Metrics Computation:**
   - Execute `computeMetrics.m` to calculate detailed performance and safety metrics (DRAC, TTC, InpuT, ACC, JRK) for each IFT configuration.
   - The module uses parallel computing where applicable and saves intermediate results.

4. **Accumulated Metrics and Visualization:**
   - Run `computeAccumulatedMetrics.m` to generate cumulative plots of the metrics and compute summary tables (mean ± standard deviation).
   - The final results are saved in `last_result.mat` for further analysis or reporting.

## Contributing

Contributions are welcome! Please feel free to:
- Open an issue if you encounter any bugs or have suggestions.
- Submit a pull request with improvements or new features.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **MATLAB & Control System Toolbox:** Essential for simulating and analyzing the control system.
- **Modular Code Design:** Enhances clarity, testing, and maintenance of the project.
- **Community Contributions:** Thanks to everyone contributing ideas and code improvements.

Happy coding and safe driving!

