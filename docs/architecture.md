# Architecture Overview

This repository documents the FPGA-based control layer for an autonomous maze robot developed during the TU Delft EE1L2 IP-2 “Building a Smart Robot” project.

## FPGA / PC Split

The system separates high-level route planning from low-level robot control:

- PC: computes maze route and encodes movement instructions for the robot.
- FPGA: handles UART/XBee communication, decodes instructions, manages sensors, and controls motors at hardware speed.

This split keeps the FPGA focused on deterministic real-time control while the PC handles planning and monitoring.

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

## Modular, FSM-Based Design

The control stack is intentionally modular to support clear signal flow and verification.

- `src/communication` contains UART and instruction encoding logic.
- `src/controllers` contains the main finite-state machine, direction control, and motor PWM logic.
- `src/sensors` contains ultrasonic timing and measurement logic.
- `src/top/robot.sv` integrates the major subsystems into a single robot controller.

## Why the Route Planner Remains on PC

Route planning was kept on the PC to simplify the embedded design and enable faster experimentation with maze strategies.
The FPGA implements the embedded control layer that executes encoded movement commands, handles sensor feedback, and manages the robot state machine.
