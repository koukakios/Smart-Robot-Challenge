# Testing and Simulation

This repository includes simulation testbenches for the major modules in the FPGA control stack.

## Included Testbenches

- `tb/comm_control_tb.sv`
- `tb/directioncontrol_tb.sv`
- `tb/maincontroller_tb.sv`
- `tb/motorcontrol_tb.sv`
- `tb/robot_tb.sv`
- `tb/timebase_tb.sv`
- `tb/uart_tb.sv`
- `tb/ultrasonic_tb.sv`

## Running Simulations

The testbenches are intended for standard Verilog simulators such as QuestaSim or ModelSim.
A generic workflow is:

1. Compile the source files from `src/` and the target testbench in `tb/`.
2. Launch the simulator with the testbench top-level module.
3. Run the simulation with a command like `run -all`.

The exact compile and simulation commands are toolchain-specific. For example:

```sh
vlog src/**/*.sv tb/maincontroller_tb.sv
vsim work.maincontroller_tb
run -all
```

## Notes

The repository is maintained for portfolio and review purposes. Some source files may depend on the original lab environment and simulator setup used during the course.
