# FPGA-Based Smart Robot Controller

SystemVerilog-based FPGA control stack for an autonomous line-following maze robot, with UART/XBee communication, ultrasonic obstacle detection, PWM motor control, and PC-side route-planning integration.

> University group project from TU Delft EE1L2 IP-2 “Building a Smart Robot”. This repository focuses mainly on the FPGA/embedded-control layer.

## Key Features

- FSM-based main robot controller
- UART communication controller
- direction decoder for encoded movement instructions
- PWM motor control
- line-following direction control
- ultrasonic distance measurement controller
- wall/distance encoding for route-planner feedback
- simulation testbenches for major modules
- FPGA constraint files

## System Architecture

PC Route Planner (C)
        |
     XBee UART
        |
FPGA UART RX/TX
        |
Communication Controller
        |
Main Controller FSM
   |          |          |
Direction   Ultrasonic   Motor PWM
Control     Controller   Controller
   |
Robot motors / sensors

## Repository Structure

- src/top/ — top-level robot integration
- src/controllers/ — main control FSM and motor direction logic
- src/communication/ — UART, instruction decoding, and communication helpers
- src/sensors/ — ultrasonic sensor timing and measurement logic
- src/timing/ — shared timebase logic
- src/constraints/ — FPGA constraint files
- 	b/ — simulation testbenches
- docs/ — architecture, protocol, FSM, and testing documentation
- legacy/ — non-primary lab artifacts and backups

## Protocol Overview

The robot receives encoded 8-bit instruction bytes from a PC-side planner and sends compact obstacle/distance status back to the PC. The instruction packet format includes redundancy and a small direction payload to support reliable embedded decoding.

## FPGA Modules

| Module | File | Responsibility |
|---|---|---|
| Top-level integration | src/top/robot.sv | Connects core controllers, sensors, UART, and PWM outputs |
| Main robot FSM | src/controllers/main_controller.sv | Decides movement actions and communication timing |
| Communication FSM | src/controllers/communication_control.sv | Sequences ultrasonic measurement, transmit, and receive states |
| Direction control | src/controllers/direction_controller.sv | Converts actions into motor drive signals and line-following behavior |
| PWM motor controller | src/controllers/motorcontrol.sv | Generates motor PWM waveform based on direction and timing |
| UART interface | src/communication/uart.sv | Implements transmit and receive UART modules for XBee communication |
| Instruction decoder | src/communication/direction_decoder.sv | Decodes 8-bit command words into movement actions |
| Wall/distance encoder | src/communication/wall_detection_encoder.sv | Encodes obstacle distance data for the planner |
| Ultrasonic controller | src/sensors/ultrasonic_controller.sv | Interfaces with the ultrasonic sensor and provides distance measurements |
| Timebase logic | src/timing/timebase.sv | Provides reusable timing counters for controllers |

## Simulation / Testbenches

Major testbenches are available in 	b/:

- 	b/comm_control_tb.sv
- 	b/directioncontrol_tb.sv
- 	b/maincontroller_tb.sv
- 	b/motorcontrol_tb.sv
- 	b/robot_tb.sv
- 	b/timebase_tb.sv
- 	b/uart_tb.sv
- 	b/ultrasonic_tb.sv

See docs/testing.md for general guidance on running simulations.

## Hardware Context

- FPGA board used for robot control
- UART/XBee wireless communication link
- Ultrasonic sensor for obstacle detection
- Colour sensors for line following
- PWM-controlled motor driver

## Status

- Archived university project
- Code is kept for portfolio/review purposes
- Some files may depend on the original lab environment/toolchain

## What I Worked On / Technical Focus

This repository demonstrates FPGA-based embedded control design, including SystemVerilog FSM design, UART communication, sensor interfacing, motor-control logic, and hardware/software integration. It is presented honestly as part of a university group project rather than a commercial product.

## Skills Demonstrated

- SystemVerilog
- FSM design
- UART communication
- FPGA-based motor control
- sensor interfacing
- embedded robotics
- testbench-driven verification
- hardware/software co-design

## License / Academic Note

This repository is shared for portfolio and review purposes and originates from a university group project. It is not a maintained commercial robotics framework.
