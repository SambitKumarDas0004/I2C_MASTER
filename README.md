# I2C_MASTER
Master block of an I2C bus 

This project implements an I2C (Inter-Integrated Circuit) Master Controller, designed in 
Verilog HDL and taken through a complete RTL-to-GDS physical design flow. The design follows
the I2C protocol specification, supporting address transmission, data transfer, acknowledgment
handling, repeated start, and stop conditions using open-drain SDA and SCL lines.

The objective of this project is to demonstrate protocol-aware RTL design, finite state machine (FSM)
implementation, clock-domain handling, and ASIC physical design best practices using industry-standard EDA tools.






![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/main/i2c_bus_data_transfer.jpg)
What I am trying to impliment.



![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/035022812bc331aca3dd630181e2cf94d7321e03/i2c_master_sim_waveform.jpg)
1. Simulation Waveform

   
This waveform shows the functionality of the master. When start pulse is applied, present state will change from IDEAL to START also sda and scl goes slow. Then the next state will be address transfer state. Master controller will send serial address to sda from msb to lsb. Lsb determines the read or write operation. For read lsb must be 1 and for write lsb must be 0. Then next state will be acknowledgement state. If sda is 0 then master will continue data transaction, and stops the transaction if sda is 1. upto 1000ns it is data write and from 1000ns to 2000ns it is read operation.














![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/7b9284aedcbfcc8c0cf88a59c957c2bc8d02bb83/i2c_master_schematic.jpg)
2. Synthesis Output (Cadence Genus)

-RTL synthesized using Genus Synthesis Solution

-Optimized gate-level netlist generated

-FSM logic, counters, control paths, and I²C timing logic verified

-Area, power, and timing optimized under given constraints

-Technology-mapped standard cells used
















![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/main/i2c_master_fp.jpg)
3. Floorplanning

-Core area defined with proper aspect ratio

-IO pins placed for SDA, SCL, clock, and data signals

-Placement rows generated for standard cells

















![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/2699a358453e5218bf67b6156ca4c94988db2426/i2c_master_powplan.jpg)
4. Power Planning

-VDD and VSS power grid implemented

-Horizontal and vertical power straps across the core

-Well-distributed power network to reduce IR drop

-Power connectivity verified across all standard cells

















![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/main/i2c_master_route.jpg)
5. Routing












![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/main/i2c_master_placement.jpg)
6. Standard Cell Placement

















![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/main/i2c_master_nano_route.jpg)
7. Nano Routing

-NanoRoute used for detailed routing

-All signal, clock, and power nets routed
