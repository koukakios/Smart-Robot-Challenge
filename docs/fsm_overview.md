# FSM Overview

This document summarizes the main finite-state machines used in the robot control stack.

## Main Controller FSM

The `main_controller` module implements the robot state machine that coordinates sensor-based line following and movement decisions.

- `communicate`: initiates a communication cycle and waits for the next instruction.
- `decide_direction`: decodes the received command and selects a movement sequence.
- `forward_*`, `left_*`, `right_*`, `turn180_*`, `backward_*`, `visit_station_*`: execute the selected maneuver using sensor feedback and internal timing.

The main controller sends action requests to the direction controller and requests ultrasonic measurements as part of safe navigation.

## Communication Controller FSM

The `communication_control` module sequences the embedded communication process.

- `WAIT`: idle until a new communication request arrives.
- `READ_ULTRASONIC`: trigger the ultrasonic sensor and wait for a valid measurement.
- `SEND`: transmit encoded obstacle data to the PC.
- `RECEIVE`: wait for the next instruction from the PC.

This FSM uses standard ready/valid handshake signaling to decouple the UART interface from the higher-level control flow.

## Direction Controller Behavior

The `direction_controller` module converts the requested action into motor direction and reset signals.

- `follow_line`: interprets left/center/right sensor readings to steer the robot.
- `turn_left` / `turn_right`: execute discrete turning maneuvers.
- `go_backward`: perform a reverse motion when needed.
- `do_nothing`: stop the motors gracefully.

The module uses a timer-driven state machine to pace turns and forward motion in a deterministic way.

## Ultrasonic Controller Behavior

The `ultrasonic_controller` module manages the ultrasonic measurement hardware.

- `start_ultrasonic`: triggers the sensor pulse.
- `echo`: measures the returned ultrasonic signal.
- `obst`: provides a compact obstacle distance output.
- `ultrasonic_valid`: indicates when a fresh measurement is ready.

This controller isolates sensor timing from the rest of the robot logic so ultrasonic sampling does not block the main FSM.
