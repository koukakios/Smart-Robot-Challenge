# Communication Protocol

The FPGA robot receives compact encoded commands from a PC-side route planner over UART/XBee.
This repository focuses on the low-level encoding, decoding, and communication control used by the embedded robot stack.

## 8-bit Instruction Encoding

Commands are carried as 8-bit packets with a safety copy and parity check:

- Bits [7:6]: parity or checksum bits
- Bits [5:3]: duplicate/copy of the direction data
- Bits [2:0]: primary direction data

This structure helps the FPGA detect transmission errors and recover the intended movement command.

## Instruction Examples

- Start / no-operation: default value indicates waiting for a new route step.
- Forward: encoded as a forward movement instruction.
- Right: encoded as a right turn instruction.
- Left: encoded as a left turn instruction.
- 180-degree turn: encoded as a turn-around instruction.
- Backward: encoded as a reverse movement instruction.
- Visit station: encoded as a special state for navigation checkpoints.
- Default / do nothing: used when the robot is waiting for a valid next instruction.

## Obstacle and Distance Feedback

The robot returns compact obstacle information to the PC in a small encoded packet. The ultrasonic controller uses a discrete set of measured distances to support maze-edge detection and route planning feedback without transmitting raw sensor samples.

This project emphasizes the communication layer between the embedded FPGA control logic and the PC route planner, rather than the full high-level pathfinding algorithm.
