# Moving Ball

## Description

This project animates a ball moving in circular motion around a fixed point. The size of the ball, distance to the cewnter point, initial position, and angular velocity are specified by the user. It supports both clockwise and counter-clockwise movement through different values of angular velocity. To calculate values of any trigonometric function, a simple numerical approximation is used. The program utilizes the RARS bitmap display.

The program is made using the RARS simulator, which is used for RISC-V assembly programming projects. RARS is written in Java and distributed as a .jar Java archive, making it platform-independent. It can be run under any OS, including Linux, Windows, and macOS. RARS simulator can be downloaded as an operating system-independent Java archive (.JAR file) from [RARS GitHub repository](https://github.com/TheThirdOne/rars).

## Installation

The program was made with the RARS simulator: [RARS GitHub repository](https://github.com/TheThirdOne/rars).

## Usage

To run the program, follow these steps:

1. Open the RARS simulator.
2. Load the `MovingBall.asm` file into the simulator.
3. Run the program.
4. Input the following values through the Run I/O at the beginning of program execution:
   - Size of the ball
   - X coordinate of the center point
   - Y coordinate of the center point
   - Radius
   - Angular velocity (may be positive or negative)

The program maps the bitmap to the heap (base address `0x10040000`) and uses a unit width in pixels of 4. The display width and height in pixels should be set to 512. The RARS bitmap display allows you to see the result after connecting it to the pogram and inputting correct parameters.

## Example input
```sh
Provide size: 2
Provide the X coordinate of the center point: 73
Provide the Y coordinate of the center point: 23
Provide the radius: 10
Provide the angular velocity: 0.3
```
![example-1](https://github.com/user-attachments/assets/d5ea6c37-c5eb-458e-907f-0e3c588d1ebf)
![example-2](https://github.com/user-attachments/assets/b1c5b9f7-5379-4ed5-85b6-7928f9ea19f5)
![example-3](https://github.com/user-attachments/assets/75ae1234-6dee-4755-b90e-4bf1e80c9978)
![example-4](https://github.com/user-attachments/assets/1629e5ea-11ca-41c4-a4d7-8a5f8448a83b)
